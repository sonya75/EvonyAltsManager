import autoevony.gui.MainScreen;
import flash.events.Event;
import autoevony.common.Utils;
import autoevony.player.LoginHelper;
import com.evony.common.beans.ResourceBean;
import com.evony.common.beans.TroopBean;
import autoevony.event.WarLogEvent;
import autoevony.net.Connection;
import r1.deval.rt.Env;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.Base64Encoder;
import flash.utils.ByteArray;
function getallresources(){
	y=new Object();
	for each(x in MainScreen.getCities()){
		y.gold=y.gold?(y.gold+x.cm.resource.gold):x.cm.resource.gold;
		y.food=y.food?(y.gold+x.cm.resource.food.amount):x.cm.resource.food.amount;
		y.wood=y.wood?(y.wood+x.cm.resource.wood.amount):x.cm.resource.wood.amount;
		y.stone=y.stone?(y.stone+x.cm.resource.stone.amount):x.cm.resource.stone.amount;
		y.iron=y.iron?(y.iron+x.cm.resource.iron.amount):x.cm.resource.iron.amount;
	}
	return Utils.resourceBeanToString(new ResourceBean(y));
}
function getalltroops(){
	y=new Object();
	for each(x in MainScreen.getCities()){
		for (p in x.cm.allTroop.toObject()){
			y[p]=(y[p]!=null)?(y[p]+x.cm.allTroop[p]):x.cm.allTroop[p];
		}
	}
	return Utils.troopBeanToString(new TroopBean(y));
}
function getattackcount(){
	i=0;
	for each(x in MainScreen.getCities()){
		i+=x.cm.enemyArmies.length;
	}
	return i;
}
function addwarloglistener(){
    if (warlogcities==null){
        warlogcities=new Array();
    }
    for (q=0;q<warlogcities.length;q++){
        for each(p in MainScreen.getCities()){
            if (p==warlogcities[q]){
                continue;
            }
            warlogcities.splice(q,1);
        }
    }
    for each(p in MainScreen.getCities()){
        if (warlogcities.indexOf(p)==-1){
            p.cm.addEventListener(WarLogEvent.TYPE,getCallback("updatewarlog"));
        }
    }
}
function allstatus(){
	uv=new Object();
	uv["player"]=c.player.toObject();
    for each(p in uv.player.castlesArray){
        q=MainScreen.getCityStateFromCastleId(p.id);
        p.researches=MainScreen.getCityStateFromCastleId(p.id).cm.researches;
        p.enemyArmies=q.cm.enemyArmies;
        p.enemyValleyArmies=q.cm.enemyValleyArmies;
        p.enemyColonyArmies=q.cm.enemyColonyArmies;
        p.friendlyArmies=q.cm.friendlyArmies;
        p.troop=q.cm.allTroop;
        p.availableTroop=q.cm.troop;
        p.fortificationProduceQueue=q.cm.fortificationProduceQueue;
        p.troopProduceQueue=q.cm.troopProduceQueue;
    }
    uv.player.selfArmies=c.ac[0].cm.selfArmies;
    uv.player=compressString(uv.player);
    uv['server']=LoginHelper.getInstance().strserverAlias+" ("+LoginHelper.getInstance().server+")";
    uv['accname']=MainScreen.getCities()[0].player.playerInfo.accountName;
    uv["summary_resources"]=getallresources();
	uv["summary_troops"]=getalltroops();
	uv["summary_attacks"]=getattackcount();
	uv["summary_username"]=MainScreen.getCities()[0].player.playerInfo.userName;
    if (!(getStatic("allwarlogs"))) setStatic("allwarlogs",new Array());
    getCallback("addwarloglistener")();
	uv.warlog=getStatic("allwarlogs").join("");
    return uv;
}
function compressString(ty){
    rt=new ByteArray();
    rt.writeObject(ty);
    rt.compress();
    rst=new Base64Encoder();
    rst.encodeBytes(rt);
    return rst.toString();
}
function updatewarlog(evt){
    if (getStatic("allwarlogs").length>=100){
        getStatic("allwarlogs").shift();
    }
    getStatic("allwarlogs").push("<font color=\'" +"#006666"+ "\'>" + Utils.getLogTimeStr(Utils.getServerTime()) + "</font> <font color=\'" + "#000000" + "\'>" + evt.logText + "</font>\n")
}
function sendstatus(uv){
    if (getStatic("STOPSTATUSUPDATE")){
        return;
    }
	if (!(httpreq)){
        httpreq=new HTTPService();
        httpreq.addEventListener(ResultEvent.RESULT,getCallback("dfg"));
        httpreq.addEventListener(FaultEvent.FAULT,getCallback("dfg"));
        httpreq.url=url;
        httpreq.method="POST";
    }
	httpreq.send(allstatus());
}
function dfg(evt){
    if (evt.type==ResultEvent.RESULT){
        c.cm.logMsg("Successfully sent status update");
    }
    else{
        c.cm.logMsg("Failed to send status update");
    }
}
function updater(){
	if (getStatic("STOPSTATUSUPDATE")){
        return;
	}
	if (!(Connection.getInstance().authenticated)){
		Utils.callLater(10000,getCallback("updater"));
		return;
	}
	getCallbackVars("sendstatus").url="http:/"+"|REPLACEWITHURL|";
    getCallback("sendstatus")();
	Utils.callLater(30000,getCallback("updater"));
}
function stopupdate(evt){
	setStatic("STOPSTATUSUPDATE",true);
    for each(p in getCallbackVars("allstatus").warlogcities){
        p.cm.removeEventListener(WarLogEvent.TYPE,getCallback("updatewarlog"));
    }
    MainScreen.getInstance().removeEventListener("STOPSTATUSUPDATE",getCallback("stopupdate"));
    deleteCallback("stopupdate");
    getCallbackVars("sendstatus").httpreq.removeEventListener(ResultEvent.RESULT,getCallback("dfg"));
    getCallbackVars("sendstatus").httpreq.removeEventListener(FaultEvent.FAULT,getCallback("dfg"));
    deleteCallback("dfg");
    deleteCallback("sendstatus");
}
function setcall(y){
    if (getCallback(y.name)){
        deleteCallback(y.name);
    }
    setCallback(y);
}
function initializ(){
	if (getStatic("STATUSUPDATERUNNING")){
		c.cm.logMsg("Status update already running");
		return;
	}
	c.cm.logMsg("Starting it");
    setStatic("STATUSUPDATERUNNING",true);
    setStatic("STOPSTATUSUPDATE",false);
	setcall(updater);
	setcall(updatewarlog);
	setcall(sendstatus);
	setcall(dfg);
    setcall(allstatus);
    setcall(stopupdate);
    setcall(addwarloglistener);
	MainScreen.getInstance().addEventListener("STOPSTATUSUPDATE",getCallback("stopupdate"));
	updater();
}
echo $m_dyn.initializ()$
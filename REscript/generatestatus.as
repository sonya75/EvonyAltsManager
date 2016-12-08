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
function bytearraytostring(x){
    s="";
    for (i=0;i<x.length;i++){
        s+=("0"+x[i].toString(16)).substr(-2,2);
    }
    return s;
}
function getAllTroopsInQueues(kl){
    _loc1_=new Object();
    troopIntNames=new Array("","","peasants","militia","scouter","pikemen","swordsmen","archer","carriage","lightCavalry","heavyCavalry","ballista","batteringRam","catapult","","","","","");
    for each(p in troopIntNames){
    	if (p!=''){
    		_loc1_[p]=0;
    	}
    }
    _loc2_=Utils.getServerTime();
    for each(_loc4_ in kl.cm.troopProduceQueue)
    {
    	_loc3_ = -1;
    	for each(_loc5_ in _loc4_.allProduceQueueArray)
            {
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc5_.endTime;
               }
               else
               {
                  _loc3_ = _loc3_ + _loc5_.costTime * 1000;
               }
               if(_loc3_ >= _loc2_ + 1000)
               {
                  _loc1_[troopIntNames[_loc5_.type]] = _loc1_[troopIntNames[_loc5_.type]] + _loc5_.num;
               }
            }
         }
         return _loc1_;
      }
function researchtoobject(x)
	      {
         return {
            "avalevel":x.avalevel,
            "castleId":x.castleId,
            "conditionBean":(x.conditionBean?x.conditionBean.toObject():(new Object())),
            "endTime":x.endTime,
            "enhancedstarlv":x.enhancedstarlv,
            "help":x.help,
            "level":x.level,
            "startTime":x.startTime,
            "typeId":x.typeId,
            "permition":x.permition,
            "upgradeing":x.upgradeing
         };
      }

function getAllFortificationInQueues(kl){
    _loc1_=new Object();
    troopIntNames=new Array("","","","","","","","","","","","","","","trap","abatis","arrowTower","rollingLogs","rockfall");
    for each(p in troopIntNames){
    	if (p!=''){
    		_loc1_[p]=0;
    	}
    }
    _loc2_=Utils.getServerTime();
    for each(_loc4_ in kl.cm.fortificationProduceQueue)
    {
    	_loc3_ = -1;
    	for each(_loc5_ in _loc4_.allProduceQueueArray)
            {
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc5_.endTime;
               }
               else
               {
                  _loc3_ = _loc3_ + _loc5_.costTime * 1000;
               }
               if(_loc3_ >= _loc2_ + 1000)
               {
                  _loc1_[troopIntNames[_loc5_.type]] = _loc1_[troopIntNames[_loc5_.type]] + _loc5_.num;
               }
            }
         }
         return _loc1_;
      }
function armybeantoobject(x)
      {
         return {
            "alliance":x.alliance,
            "armyId":x.armyId,
            "direction":this.direction,
            "hero":x.hero,
            "heroLevel":x.heroLevel,
            "heroid":x.heroid,
            "king":x.king,
            "missionType":x.missionType,
            "reachTime":x.reachTime,
            "resource":(x.resource?x.resource.toObject():(new Object())),
            "restTime":x.restTime,
            "startFieldId":x.startFieldId,
            "startPosName":x.startPosName,
            "startTime":x.startTime,
            "targetFieldId":x.targetFieldId,
            "targetPosName":x.targetPosName,
            "troop":(x.troop?x.troop.toObject():(new Object())),
            "selected":x.selected
         };
      }
function castletoobject(kl){
	k=kl.castle;
	xp= {
            "colonization":k.colonization,
            "fieldId":k.fieldId,
            "fortification":kl.cm.fortification.toObject(),
            "icon":k.icon,
            "id":k.id,
            "logUrl":k.logUrl,
            "name":k.name,
            "powerlevel":k.powerlevel,
            "resource":kl.cm.resource.toObject(),
            "status":k.status,
            "troop":kl.cm.allTroop.toObject(),
            "usePACIFY_SUCCOUR_OR_PACIFY_PRAY":k.usePACIFY_SUCCOUR_OR_PACIFY_PRAY,
            "zoneId":k.zoneId,
            "allowAlliance":k.allowAlliance,
            "canChangeIcon":k.canChangeIcon,
            "goOutForBattle":k.goOutForBattle,
            "hasEnemy":k.hasEnemy,
            "availableTroop":kl.cm.troop.toObject()
         };
    xp.colonies=new Array();
    for each(hty in kl.cm.colonies){
    	htr=hty.toObject();
    	htr[".prestige"]=null;
    	htr.prestige=hty.prestige;
    	xp.colonies.push(htr);
    }
    xp.troopProduceQueue=getAllTroopsInQueues(kl);
    xp.fortificationProduceQueue=getAllFortificationInQueues(kl);
    xp.selfArmies=new Array();
    for each(hty in kl.cm.selfArmies){
    	if (hty.targetFieldId==(c.getValue("Coordinate",kl.coord)) && hty.direction==1){
    		xp.selfArmies.push(armybeantoobject(hty));
    	}
    }
    xp.friendlyArmies=new Array();
    for each(hty in kl.cm.friendlyArmies){
    	xp.friendlyArmies.push(armybeantoobject(hty));
    }
    xp.enemyArmies=new Array();
    for each(hty in kl.cm.enemyArmies){
    	xp.enemyArmies.push(armybeantoobject(hty));
    }
    xp.enemyValleyArmies=new Array();
    for each(hty in kl.cm.enemyValleyArmies){
    	xp.enemyValleyArmies.push(armybeantoobject(hty));
    }
    xp.enemyColonyArmies=new Array();
    for each(hty in kl.cm.enemyColonyArmies){
    	xp.enemyColonyArmies.push(armybeantoobject(hty));
    }
    xp.localarmies=new Array();
    for each(hty in kl.cm.localArmies){
    	xp.localarmies.push(armybeantoobject(hty));
    }
    xp.herosArray=new Array();
    for each(hty in kl.cm.heroes){
    	xp.herosArray.push(hty.toObject());
    }
    xp.fieldsArray=new Array();
    for each(hty in fcm.fields){
    	xp.fieldsArray.push(hty.toObject());
    }
    xp.buildings=new Array();
    for each(hty in kl.cm.buildings){
    	xp.buildings.push(hty.toObject());
    }
    xp.buildingQueuesArray=new Array();
    for each(hty in k.buildingQueuesArray){
    	xp.buildingQueuesArray.push(hty.toObject());
    }
    xp.buffsArray=new Array();
    for each(hty in k.buffsArray){
    	xp.buffsArray.push(hty.toObject());
    }
    xp.researches=new Array();
    for each(hty in kl.cm.researches){
    	xp.researches.push(researchtoobject(hty));
    }
    xp.gears=new Array();
    for each(hty in kl.cm.gears){
    	xp.gears.push(researchtoobject(hty));
    }
    return xp;
}
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
        warlogcities=new Object();
    }
    for (ire=0;ire<MainScreen.getCities().length;ire++){
        if (warlogcities[ire]==MainScreen.getCities()[ire].castle.id){
            continue;
        }
        warlogcities[ire]=MainScreen.getCities()[ire].castle.id;
        MainScreen.getCities()[ire].cm.addEventListener(WarLogEvent.TYPE,getCallback("updatewarlog"));
    }
}
function allstatus(){
	if (uv==null){
		uv=new Object();
		uv["player"]=MainScreen.getCities()[0].player.toObject();
        uv['player']['server']=LoginHelper.getInstance().strserverAlias+" ("+LoginHelper.getInstance().server+")";
        uv['player'].playerInfo.accountName="";
        uv['accname']=MainScreen.getCities()[0].player.playerInfo.accountName;
		uv['player']['castles']=new Array();
		for each(p in MainScreen.getCities()){
			uv['player']['castles'].push(castletoobject(p));
		}
		uv["summary_resources"]=getallresources();
		uv["summary_troops"]=getalltroops();
		uv["summary_attacks"]=getattackcount();
		uv["summary_username"]=MainScreen.getCities()[0].player.playerInfo.userName;
	}
	if (warlgmsg==null){
		warlgmsg=1;
		sdst=MainScreen.getInstance().logTab.selectedIndex;
		MainScreen.getInstance().logTab.selectedIndex=2;
		c.cm.logMsg("");
		Utils.callLater(1,setCallback(allstatus));
		return;
	}
	if (startedlogging==null){
		warlgmsg=MainScreen.getInstance().logs.htmlText;
		addwarloglistener();
		startedlogging=true;
		MainScreen.getInstance().logTab.selectedIndex=sdst;
		c.cm.logMsg("");
	}
	addwarloglistener();
	uv.warlog=warlgmsg;
    uv['player']=compressString(uv['player']);
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
	warlgmsg+=("<font color=\'" +"#006666"+ "\'>" + Utils.getLogTimeStr(Utils.getServerTime()) + "</font> <font color=\'" + "#000000" + "\'>" + evt.logText + "</font>\n");
}
function sendstatus(url){
    if (stpupdate){
        return;
    }
	if (uv==null){
		uv=null;
		allstatus();
		Utils.callLater(1,getCallback("sendstatus"),[url]);
		return;
	}
	httpreq=new HTTPService();
	httpreq.addEventListener(ResultEvent.RESULT,getCallback("dfg"));
	httpreq.addEventListener(FaultEvent.FAULT,getCallback("dfg"));
    httpreq.url=url;
	httpreq.method="POST";
	httpreq.send(uv);
	uv=null;
}
function dfg(evt){
	httpreq.removeEventListener(ResultEvent.RESULT,getCallback("dfg"));
    httpreq.removeEventListener(FaultEvent.FAULT,getCallback("dfg"));
}
function ddss(){
	sendstatus("http:/"+"|REPLACEWITHURL|");
}
function updater(){
	if (stpupdate){
		for each(p in warlogcities){
			p.cm.removeEventListener(WarLogEvent.TYPE,getCallback("updatewarlog"));;
		}
		MainScreen.getInstance().removeEventListener("STOPSTATUSUPDATE",getCallback("stopupdate"));
		return;
	}
	if (!(Connection.getInstance().authenticated)){
		Utils.callLater(10000,getCallback("updater"));
		return;
	}
	ddss();
	Utils.callLater(30000,getCallback("updater"));
}
function stopupdate(evt){
	stpupdate=true;
}
function initializ(){
	Env.INFINITE_LOOP_LIMIT=1000000;
	if (MainScreen.getInstance().hasEventListener("STATUSUPDATERUNNING")){
		c.cm.logMsg("Stopping update");
        MainScreen.getInstance().dispatchEvent(new Event("STOPSTATUSUPDATE"));
		MainScreen.getInstance().removeEventListener("STATUSUPDATERUNNING",MainScreen.getInstance().disableLogoutButton);
		return;
	}
	c.cm.logMsg("Starting it");
	MainScreen.getInstance().addEventListener("STATUSUPDATERUNNING",MainScreen.getInstance().disableLogoutButton);
	warlgmsg=null;
	stpupdate=false;
	warlogcities=null;
	setCallback(updater);
	setCallback(updatewarlog);
	setCallback(sendstatus);
	setCallback(dfg);
	MainScreen.getInstance().addEventListener("STOPSTATUSUPDATE",setCallback(stopupdate));
	updater();
}
echo $m_dyn.initializ()$

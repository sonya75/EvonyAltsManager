# EvonyAltsManager

To use this you will need a webserver and MySQL database. In windows, you can install xampp to get them.

Once you have a webserver and a MySQL database running, create a user for the MySQL database and a database for this app to use and give the user full permission to the database.

Clone this repository or download it as a zip and extract it in some folder in your webserver. For this app to work, all the files in this repository will need to be in a folder named EvonyAltsManager-master. Once you have done it, open the link to the index.php file in the folder in your browser. There you will first have to create an admin username and a password which this app will store and when you want to change its settings, you will have to use that username and password. Once the username and password is created, you will be refirected to a page where you will need to enter the MySQL database name, the name of the user you created in the MySQL database and its password.

Once you are done, open the link to the update.php file in your browser. It will update it to the current version using GitHub and update the RE script in the REscript folder to make it usable.

At last, you will need to run the following script in RE to send updates to your server and you can see the updates by opening the link to the index.html file your browser.

```
//In the following line replace url_here by the link to the generatestatus.as file in the 
//REscript folder without http or https at the beginning, like 
//for example:- www.example.com/EvonyAltsManager-master/REscript/generatestatus.as

set downloadlocation url_here
set timeout 30
echo $m_dyn.sendrequest()$
sleep {2*%timeout%}

import autoevony.common.Utils;
import autoevony.gui.MainScreen;
import flash.utils.Timer;
import flash.events.TimerEvent;
import mx.rpc.http.HTTPService;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
function setcall(yt){
	if (getCallback(yt.name)){
		deleteCallback(yt.name);
	}
	setCallback(yt);
}
function sendrequest(){x = new HTTPService();
x.url="http:/"+"/"+getVar("downloadlocation")+"?random="+(new Date().getTime());
x.resultFormat='text';
x.addEventListener(FaultEvent.FAULT,setcall(receiveddata));
x.addEventListener(ResultEvent.RESULT,getCallback("receiveddata"));
x.send();
timr=new Timer(getVar("timeout")*1000,1);
timr.addEventListener(TimerEvent.TIMER,getCallback("receiveddata"));
timr.start();
getCallbackVars("receiveddata").timr=timr;
getCallbackVars("receiveddata").x=x;}
function dummy(evt){}
function receiveddata(evt){
timr.stop();
x.removeEventListener(ResultEvent.RESULT,getCallback("receiveddata"));
x.removeEventListener(FaultEvent.FAULT,getCallback("receiveddata"));
timr.removeEventListener(TimerEvent.TIMER,getCallback("receiveddata"));
deleteCallback("receiveddata");
MainScreen.getInstance().getCityPanel(c.castle.id).getScript().stop();
if (evt.type==TimerEvent.TIMER || evt.type==FaultEvent.FAULT) {
c.cm.logMsg("Error downloading script");
return;
}
Utils.callLater(10,setcall(runit),[evt.message.body]);}
function runit(dat){
deleteCallback("runit");
MainScreen.getInstance().getCityPanel(c.castle.id).getScript().set_m_script(dat);
MainScreen.getInstance().getCityPanel(c.castle.id).getScript().start();}
```

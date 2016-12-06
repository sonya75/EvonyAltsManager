<?php
error_reporting(0);
$info=include("config/savedconfig.php");
if (!($info)){
	header("location:config.php");
	exit();
}
$user=$info["dbuser"];
$pass=$info["dbpwd"];
$database=$info["dbname"];
if ((!$user)||(!$pass)||(!$database)){
	header("location:config.php");
	exit();
}
if ($_SERVER["REQUEST_METHOD"]!="POST"){
	header("location:index.html");
	exit();
}
$conn=new mysqli("localhost",$user,$pass);
$conn->select_db($database) or die("Unable to select database.");
$json=json_decode($_POST['data'],true);
$id=md5($json["player"]["playerInfo"]["accountName"]."12e81he871hfd287h81e");
$resources=$json["summary"]["resources"];
$troops=$json["summary"]["troops"];
$attacks=$json["summary"]["attacks"];
$accname=$json["summary"]["accname"];
$query="CREATE TABLE IF NOT EXISTS ACCOUNTS_SUMMARY ( NAME TINYTEXT, RESOURCES TEXT, TROOPS TEXT, ATTACKS INT, ID TINYTEXT);";
$conn->query($query);
$query="ALTER IGNORE TABLE ACCOUNTS_SUMMARY ADD LASTUPDATED INT;";
$conn->query($query);
$query="ALTER IGNORE TABLE ACCOUNTS_SUMMARY ADD UNIQUE NAME;";
$conn->query($query);
$query="ALTER IGNORE TABLE ACCOUNTS_SUMMARY ADD UNIQUE ID;";
$conn->query($query);
$check=$conn->prepare("SELECT COUNT(*) FROM ACCOUNTS_SUMMARY WHERE ID= ? ");
$check->bind_param('s',$id);
$check->execute();
$check->bind_result($rows);
$check->fetch();
$check->close();
if ($rows>0){
	$stm=$conn->prepare("UPDATE ACCOUNTS_SUMMARY SET NAME= ? , RESOURCES= ? , TROOPS= ? , ATTACKS= ? , LASTUPDATED = ? WHERE ID= ?");
	$curtime=time();
	$stm->bind_param('sssdsd',$accname,$resources,$troops,$attacks,$curtime,$id);
	$stm->execute();
	$stm->close();
}
else{
	$check=$conn->prepare("SELECT COUNT(*) FROM ACCOUNTS_SUMMARY WHERE NAME = ? ");
	$check->bind_param('s',$accname);
	$check->execute();
	$check->bind_result($rows);
	$check->fetch();
	$check->close();
	if ($rows>0){
		$stm=$conn->prepare("UPDATE ACCOUNTS_SUMMARY SET ID= ? , RESOURCES= ? , TROOPS= ? , ATTACKS= ? , LASTUPDATED = ? WHERE NAME= ?");
		$curtime=time();
		$stm->bind_param('sssdsd',$id,$resources,$troops,$attacks,$curtime,$accname);
		$stm->execute();
		$stm->close();
	}
	else{
		$stm=$conn->prepare("INSERT INTO ACCOUNTS_SUMMARY (NAME, RESOURCES, TROOPS, ATTACKS, ID, LASTUPDATED ) VALUES ( ? , ? , ? , ? , ? , ? )");
		$curtime=time();
		$stm->bind_param('sssdsd',$accname,$resources,$troops,$attacks,$id,$curtime);
		$stm->execute();
		$stm->close();
	}
}
$conn->close();
$json['player']['playerInfo']['accountName']="";
$json["summary"]="";
$fp=fopen("playerdata/".$id.".json",'w');
fwrite($fp,json_encode($json));
fclose($fp);
?>

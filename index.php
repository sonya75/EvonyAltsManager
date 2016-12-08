<?php
error_reporting(0);
require_once( 'amfphp/core/amf/app/Gateway.php');
require_once( AMFPHP_BASE . 'amf/io/AMFSerializer.php');
require_once( AMFPHP_BASE . 'amf/io/AMFDeserializer.php');
echo "LOADED";
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
echo "RECEIVED";
$conn=new mysqli("localhost",$user,$pass);
$conn->select_db($database) or die("Unable to select database.");
$id=md5($_POST['accname']."12e81he871hfd287h81e");
$resources=$_POST['summary_resources'];
$troops=$_POST["summary_troops"];
$attacks=$_POST["summary_attacks"];
$username=$_POST["summary_username"];
$query="CREATE TABLE IF NOT EXISTS ACCOUNTS_SUMMARY ( RESOURCES TEXT, ALLIANCE TINYTEXT, TROOPS TEXT, ATTACKS INT, LASTUPDATED INT, NAME TINYTEXT, ID TINYTEXT);";
$conn->query($query);
$query="ALTER IGNORE TABLE ACCOUNTS_SUMMARY ADD ALLIANCE TINYTEXT;";
$conn->query($query);
$check=$conn->prepare("SELECT COUNT(*) FROM ACCOUNTS_SUMMARY WHERE ID= ? ");
$check->bind_param('s',$id);
$check->execute();
$check->bind_result($rows);
$check->fetch();
$check->close();
$data=$_POST['player'];
$rawdata=base64_decode($data);
$data=gzuncompress($rawdata);
$amf = new AMFObject($data);
$deserializer = new AMFDeserializer($amf->rawData);
$json=($deserializer->readAmf3Data());
$js= array();
$js['player']=$json;
$js['server']=$json['server'];
$js['warlog']=$_POST['warlog'];
$alliance=$json['playerInfo']['alliance'];
if ($rows>0){
	$stm=$conn->prepare("UPDATE ACCOUNTS_SUMMARY SET NAME= ? , ALLIANCE= ?, RESOURCES= ? , TROOPS= ? , ATTACKS= ? , LASTUPDATED = ? WHERE ID= ?");
	$curtime=time();
	$stm->bind_param('ssssdds',$username,$alliance,$resources,$troops,$attacks,$curtime,$id);
	$stm->execute();
	$stm->close();
}
else{
	$stm=$conn->prepare("INSERT INTO ACCOUNTS_SUMMARY (NAME, ALLIANCE, RESOURCES, TROOPS, ATTACKS, ID, LASTUPDATED ) VALUES ( ? , ? , ? , ? , ? , ? )");
	$curtime=time();
	$stm->bind_param('ssssdsd',$username,$alliance,$resources,$troops,$attacks,$id,$curtime);
	$stm->execute();
	$stm->close();
}
$conn->close();
$fp=gzopen("playerdata/".$id.".json",'w');
gzwrite($fp,json_encode($js));
gzclose($fp);
?>

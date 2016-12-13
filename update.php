<?php
ob_start();
error_reporting(0);
$var=include("config/savedconfig.php");
if (!($var)){
	header("location:index.php");
	exit();
}
$user1=$var["username"];
$pass1=$var["pass"];
if (!$user1){
	header("location:index.php");
	exit();
}
$authstr=md5($user1."d92f29f9fu".$pass1);
if ($_SERVER["REQUEST_METHOD"]=="POST"){
	$authstr1=$_COOKIE["SESSID"];
	if (!($authstr1)){
		$user=$_POST["username"];
		$pass=$_POST["pass"];
		$authstr2=md5($user."d92f29f9fu".$pass);
	}
	else{
		$authstr2=$authstr1;
	}
	if ($authstr==$authstr2){
		if (!($authstr1)){
			setcookie("SESSID",$authstr,time()+36000);
		}
		file_put_contents("altsmanager.zip",fopen("https://github.com/sonya75/EvonyAltsManager/archive/master.zip",'r'));
		$zip = new ZipArchive;
		$res = $zip->open('altsmanager.zip');
		if ($res === TRUE) {
  			$zip->extractTo('../');
  			$zip->close();
  			echo "Successfully updated.";
  			$fp=fopen("lastupdated",'w');
  			fwrite($fp,time());
  			fclose($fp);
  			$fp=fopen("REscript/generatestatus.as",'r');
  			$data=fread($fp,filesize("REscript/generatestatus.as"));
  			fclose($fp);
  			$fp=fopen("REscript/generatestatus.as",'w');
  			$scripturl="/".$_SERVER["HTTP_HOST"].dirname($_SERVER["PHP_SELF"])."/index.php";
  			$data=str_replace("|REPLACEWITHURL|",$scripturl,$data);
  			fwrite($fp,$data);
  			fclose($fp);
  			exit();
		}
		else{
			echo "Update failed";
		}
	}
	else{
		echo "Authentication failed.";
		exit();
	}
}
if ($_COOKIE["SESSID"]){
	if ($authstr==$_COOKIE["SESSID"]){
		echo "<html><body><form method='post' action='update.php' id='form1'></form><button type='submit' value='Submit' form='form1'>Update</button></html></body>";
		exit();
	}
}
echo "<html><body><h2>Authentication</h2><form method='post' action='update.php' id='form1'><p>Username: <input id='username' name='username'></p><p>Password: <input id='pass' type='password' name='pass'></p></form><button type='submit' form='form1' value='Submit'>Update</button></body></html>";
?>

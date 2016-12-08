<?php
error_reporting(0);
$var = include("config/savedconfig.php");
$user=$var['username'];
$password=$var['pass'];
if ($_SERVER['REQUEST_METHOD'] === 'POST'){
	if (!($user)){
		$user=$_POST["username"];
		$pass=$_POST["pass"];
		if (!($user)){
			exit();
		}
		if (!is_dir("config")){
			mkdir("config",0777,true);
			$fp=fopen("config/.htaccess",'w');
			fwrite($fp,"DENY FROM ALL");
			fclose($fp);
		}
		$fp=fopen("config/savedconfig.php",'w');
		fwrite($fp,"<?php return array ( 'username' => '$user', 'pass' => '$pass' ); ?>");
		fclose($fp);
		setcookie("SESSID", md5($user."d92f29f9fu".$pass), time()+36000);
		header("location:config.php");
		exit();
	}
	$authstr=md5($user."d92f29f9fu".$password);
	$dbname=$_POST["dbname"];
	$authstr1=$_COOKIE["SESSID"];
	if (!($authstr1)){
		$user1=$_POST["username"];
		$pass1=$_POST["pass"];
		$authstr1=md5($user1."d92f29f9fu".$pass1);
	}
	$dbuser=$_POST["dbuser"];
	$dbpwd=$_POST["dbpwd"];
	if ($authstr==$authstr1){
		setcookie("SESSID",md5($user."d92f29f9fu".$password), time()+36000);
		$fp=fopen("config/savedconfig.php",'w');
		fwrite($fp,"<?php return array ( 'username' => '$user', 'pass' => '$password', 'dbname' => '$dbname', 'dbuser' => '$dbuser', 'dbpwd' => '$dbpwd');?>");
		fclose($fp);
		echo "Configuration saved successfully.";
		exit();
	}
	else{
		echo "Authetication failed.";
		exit();
	}
}
if (!($user)){
	echo "<html><body><h2>Create User-password</h2><form method='post' action='config.php' id='form1'><p>Username: <input id='username' name='username'></p><p>Password: <input id='pass' type='password' name='pass'></p></form><button type='submit' form='form1' value='Submit'>Submit</button></body></html>";
	exit();
}
if ($_COOKIE["SESSID"]){
	$authstr1=$_COOKIE["SESSID"];
	$authstr=md5($user."d92f29f9fu".$password);
	if ($authstr1==$authstr){
		echo "<script type='text/javascript'>window.onload=function (){document.getElementById('auth').style.display='none';};</script>";
	}
}
?>
<html>
<body>
<h2>Configuration</h2>
<form method="post" action="config.php" id="form1">
<p>Database Name: <input id="dbname" name="dbname"></p>
<p>Database User: <input id="dbuser" name="dbuser"></p>
<p>Password for Database: <input id="dbpwd" name="dbpwd"></p>
<br><br>
<div id="auth">
<h2>Authetication</h2>
<p>Enter Username: <input id="username" name="username"></p>
<p>Password: <input id="pass" type="password" name="pass"></p>
</div>
</form>
<button type="submit" form="form1" value="Submit">Submit</button>
</body>
</html>

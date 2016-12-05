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
		header("location:config.php");
		exit();
	}
	$dbname=$_POST["dbname"];
	$user1=$_POST["username"];
	$pass1=$_POST["pass"];
	$dbuser=$_POST["dbuser"];
	$dbpwd=$_POST["dbpwd"];
	if (($user1==$user)&&($pass1==$password)){
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
?>
<html>
<body>
<h2>Configuration</h2>
<form method="post" action="config.php" id="form1">
<p>Database Name: <input id="dbname" name="dbname"></p>
<p>Database User: <input id="dbuser" name="dbuser"></p>
<p>Password for Database: <input id="dbpwd" name="dbpwd"></p>
<br><br>
<h2>Authetication</h2>
<p>Enter Username: <input id="username" name="username"></p>
<p>Password: <input id="pass" type="password" name="pass"></p>
</form>
<button type="submit" form="form1" value="Submit">Submit</button>
</body>
</html>

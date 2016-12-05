<?php
error_reporting(0);
if ($_SERVER["REQUEST_METHOD"]=="POST"){
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
	$user=$_POST["username"];
	$pass=$_POST["pass"];
	if (($user1==$user)&&($pass1==$pass)){
		file_put_contents("altsmanager.zip",fopen("https://github.com/sonya75/EvonyAltsManager/archive/master.zip",'r'));
		$zip = new ZipArchive;
		$res = $zip->open('altsmanager.zip');
		if ($res === TRUE) {
  			$zip->extractTo('../');
  			$zip->close();
  			echo "Successfully updated.";
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
echo "<html><body><h2>Authentication</h2><form method='post' action='update.php' id='form1'><p>Username: <input id='username' name='username'></p><p>Password: <input id='pass' type='password' name='pass'></p></form><button type='submit' form='form1' value='Submit'>Submit</button></body></html>";
?>

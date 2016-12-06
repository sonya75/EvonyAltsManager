<?php
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
$conn=new mysqli("localhost",$user,$pass);
$conn->select_db($database) or die("Unable to select database.");
$check=$conn->query("SELECT NAME, RESOURCES, TROOPS, ATTACKS, ID, LASTUPDATED FROM ACCOUNTS_SUMMARY ORDER BY ID");
$rows=array();
while ($row=$check->fetch_array()){
	array_push($rows,$row);
}
echo json_encode($rows);
?>

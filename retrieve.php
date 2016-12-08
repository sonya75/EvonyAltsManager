<?php
error_reporting(0);
$nam = $_GET["id"];
$fp=fopen("playerdata/".$nam.".json",'r');
$dat=fread($fp,filesize("playerdata/".$nam.".json"));
header("Content-Encoding:gzip");
echo $dat;
?>

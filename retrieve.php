<?php
error_reporting(0);
$nam = $_GET["id"];
$content=file_get_contents("playerdata/".$nam.".json");
echo $content;
?>
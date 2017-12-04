<?php
// created by Renato
$mysqli = new mysqli("XXXXXXXXX.rds.amazonaws.com", "XXXXXXX", "XXXXXXXXXXX", "XXXXXXXX");

if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: " . $mysqli->connect_error;
}


?>
<?php
// Include the SDK using the Composer autoloader
//require 'aws.phar';
//require 'aws_keys.php';
require 'dbconf.php';
include 'util.php';

$userid = 1;

if (isset($_POST['food_name'])) {
	$foodname = $_POST['food_name'];

    $res = searchFood($foodname);
    //Add Exception Handling
    	//Errors
}

/**
Returns all foods with the string $foodname in them
@param: foodname - Part or Full food name
@return: result set as JSON
*/
function searchFood($foodname) {
	require 'dbconf.php';

	//let's first check if we have that search result on REDIS
	$cachedData = getFromRedis($foodname);
	if ($cachedData) {
		return returnJSON($cachedData);
	}


	//connect to server and select DB
	$mysqli = new mysqli($dbhost, $dbusername, $dbpassword, $db_name);
	if ($mysqli->connect_errno) {
	    echo "Error connecting to MySQL: " . $mysqli->connect_error;
	}

	$query = "select * from nutrition where food_name LIKE '%$foodname%'";
	$res = $mysqli->query($query);

	$result = [];
    if ($res->num_rows > 0) {
		while ($row = $res->fetch_assoc()) {
			$entry=[];
			$entry["name"] = $row["food_name"];
			$entry["id"] = $row["id"];
			$result[] = $entry;
		}
	}

	// saving the search result on REDIS
	saveInRedis($foodname, $result);

	//return as a json
	return returnJSON($result);
}
?>
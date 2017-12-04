<?php

// Include the SDK using the Composer autoloader
//require 'aws.phar';
//require 'aws_keys.php';
require 'dbconf.php';
include 'util.php';

$userid = 1;

if (isset($_POST['foodName']) && isset($_POST['mealId']) && isset($_POST['userid'])) {
//    $result = addNumbers(intval($_POST['number1']), intval($_POST['number2']));
	$foodName = $_POST['foodName'];
	$mealId = $_POST['mealId'];
	$count = $_POST['count'];
	$unit = $_POST['unit'];
	$userid = $_POST['userid'];
	$date = $_POST['date'];

    $res = enterFood($userid, $foodName, $mealId, $count, $unit, $date);
    //Add Exception Handling
    	//Errors
}

/**
Enters a food activity for a user
@param: userid - Identified for a user
@Param: food - an array containing foodname, meal id, count & unit
@return: true if inserted, null if error
*/
function enterFood($userid, $foodName, $mealId, $count, $unit, $date) {
	require 'dbconf.php';

	//connect to server and select DB
	$mysqli = new mysqli($dbhost, $dbusername, $dbpassword, $db_name);
	if ($mysqli->connect_errno) {
	    dbError($mysqli->error);
	}

	$foodid = '';

	// Instead of Food name take nutrition.id as input
	$nquery = "SELECT nutrition.id FROM nutrition where food_name = '$foodName'";

	if ($result = $mysqli->query($nquery)) {
		while ($row = $result->fetch_row()) {
				$foodid=$row[0]; // get foodname here.
		}
	} else {
		// also try to query USDA DB to find the fooditem if not found in nutrition table
		// can make an entry into nutrition table
		// and then enter into user_foods table
	}

	$ufquery = "INSERT INTO `user_foods`(`user_id`,`food_id`,`food_name`,`meal_id`,`count`,`unit`,`created_at`, `date`)
	VALUES ($userid, '$foodid', '$foodName',$mealId, $count,'$unit', Now(), '$date')";

	if ($result = $mysqli->query($ufquery)) {
		returnJSON(array(true));
	} else {
		$r = [];
		$r['errorCode'] = "db";
		$r['errorMessage'] = $mysqli->error;
		returnJSON($r);
	}
}

?>
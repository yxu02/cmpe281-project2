<?php
// Include the SDK using the Composer autoloader
//require 'aws.phar';
//require 'aws_keys.php';
require 'dbconf.php';
include 'util.php';

$userid = 1;

if (isset($_POST['userid'])) {
	$userid = $_POST['userid'];

    $res = allUserActivity($userid);
    //Add Exception Handling
    	//Errors
}

/**
Returns all food activity for a user
@param: email - Primary Id for a user
@return: SQL result set
*/
function allUserActivity($userid) {
	require 'dbconf.php';

	//connect to server and select DB
	$mysqli = new mysqli($dbhost, $dbusername, $dbpassword, $db_name);
	if ($mysqli->connect_errno) {
	    dbError($mysqli->error);
	}

	$gquery = "select * from user_foods where user_id = $userid";
	$res = $mysqli->query($gquery);

	$foodsIDs = [];
	$foodData = [];
    if ($res->num_rows > 0) {
		while ($row = $res->fetch_assoc()) {
			if (isset($row["date"])) {
				$entry=[];
				$entry["id"] = $row["id"];
				$entry["userId"] = $row["user_id"];
				$entry["foodId"] = $row["food_id"];
				$entry["foodName"] = $row["food_name"];
				$entry["mealId"] = (integer) $row["meal_id"];
				$entry["count"] = $row["count"];
				$entry["unit"] = $row["unit"];
				$entry["date"] = $row["date"];
				//$entry["amazon_userid"] = $row["amazon_userid"];
				$foodsIDs[] = $entry["foodId"];
				//$foodData[] = $entry;
				//$foodData[$entry["date"]] = $entry;

				if (!isset($foodData[$entry["date"]])){
					$foodData[$entry["date"]] = array();
				}
				$foodData[$entry["date"]][] = $entry;

			}
		}
	}




	$foodIDsList = implode(", ", $foodsIDs);
	$gquery = "select * from nutrition where id IN ($foodIDsList)";
	$res = $mysqli->query($gquery);
	$nutritionData = [];
    if ($res->num_rows > 0) {
		while ($row = $res->fetch_assoc()) {
			$entry=[];
			$entry["foodId"] = $row["id"];
			$entry["foodName"] = $row["food_name"];

			$entry["measure"] = $row["measure"];
			$entry["calories"] = $row["energy"];
			$entry["carb"] = $row["carb"];
			$entry["protein"] = $row["protein"];
			$entry["fat"] = $row["fat"];
			$entry["water"] = $row["water"];
			$entry["sugar"] = $row["sugar"];
			$entry["fiber"] = $row["fiber"];

			$nutritionData[$entry["foodId"]] = $entry;
		}
	}




	$gquery = "select * from measurements where user_id = $userid";
	$res = $mysqli->query($gquery);

	$weightData = [];
    if ($res->num_rows > 0) {
		while ($row = $res->fetch_assoc()) {
			$entry=[];
			$entry["id"] = $row["id"];
			$entry["weight"] = $row["weight"];
			$entry["measuredAt"] = $row["measured_at"];

			$weightData[$entry["measuredAt"]] = $entry;
		}
	}


	$result = [];
	$result["food"] = $foodData;
	$result["weight"] = $weightData;
	$result["nutritionData"] = $nutritionData;


	//return as a json
	return returnJSON($result);
}

?>
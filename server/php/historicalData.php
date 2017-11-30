<?
// Include the SDK using the Composer autoloader
require 'aws.phar';
require 'aws_keys.php';
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

	$result = [];
    if ($res->num_rows > 0) {
		while ($row = $res->fetch_assoc()) {
			$entry=[];
			$entry["id"] = $row["id"];
			$entry["user_id"] = $row["user_id"];
			$entry["food_id"] = $row["food_id"];
			$entry["food_name"] = $row["food_name"];
			$entry["meal_id"] = $row["meal_id"];
			$entry["count"] = $row["count"];
			$entry["unit"] = $row["unit"];
			$entry["created_at"] = $row["created_at"];
			$entry["amazon_userid"] = $row["amazon_userid"];

			$result[] = $entry;
		}
	}

	//return as a json
	return returnJSON($result);
}

?>
<?php

require 'dbconf.php';
include 'util.php';


if (isset($_POST['weight']) && isset($_POST['userid']) && isset($_POST['dateMeasured']) ) {
//    $result = addNumbers(intval($_POST['number1']), intval($_POST['number2']));
	$weight = $_POST['weight'];
	$userid = $_POST['userid'];
	$dateMeasured = $_POST['dateMeasured'];
	$measurementId = isset($_POST['measurementId'])? $_POST['measurementId']: null;

    $res = enterWeight($userid, $weight, $dateMeasured, $measurementId);
    //Add Exception Handling
    	//Errors
}

returnJSON(array(false));

/**
Enters user measurement
@param: userid - Identified for a user
@Param: weight - user's weight
@return: true if inserted, null if error
*/
function enterWeight($userid, $weight, $dateMeasured, $measurementId = null) {
	require 'dbconf.php';

	//connect to server and select DB
	$mysqli = new mysqli($dbhost, $dbusername, $dbpassword, $db_name);
	if ($mysqli->connect_errno) {
	    dbError($mysqli->error);
	}

	$ufquery = "INSERT INTO `measurements`(`user_id`,`weight`,`measured_at`,`created_at`)
	VALUES ($userid, $weight, '$dateMeasured', Now()) ";

	if ($measurementId != null ) {
			$ufquery = "UPDATE `measurements` SET `weight` = $weight, `measured_at` = '$dateMeasured'
	WHERE `id` = $measurementId";

	}

	if ($result = $mysqli->query($ufquery)) {
		returnJSON(array(true));
	} else {
		returnJSON(array(false));
	}
}

?>
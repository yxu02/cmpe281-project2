<?php
// created by Renato
date_default_timezone_set('America/Los_Angeles');

define("API_KEY", "XXXXXXXXXXXXXXXXXX"); // simple api key to avoid adhoc requests to the server


require 'db.php';




// - - - - - - - - - - - - -
// Database functions


function doQueryInDatabase($query) {
	global $mysqli;

	$res = $mysqli->query($query);

	if ($res)
		return $res;

	returnErrorDatabase();
}


function newGUID(){	 // source: http://php.net/manual/en/function.com-create-guid.php
	$guid = random_bytes(16);
    $guid[6] = chr(ord($guid[6]) & 0x0f | 0x40);
    $guid[8] = chr(ord($guid[8]) & 0x3f | 0x80);
    $guid = vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($guid), 4));
    return $guid;
}


function generateTokenForUser($userID){
	$token = newGUID();
	$tokenExpiration = strtotime('+1 day');
	$res = doQueryInDatabase("UPDATE users281 SET token = '$token', token_expire_at = '$tokenExpiration' WHERE id = '$userID'");

	return ['token' => $token, 'expireAt' => $tokenExpiration ];
}


// returns false if not succesful or tokenData if successful
function login($email, $password) {
	global $mysqli;
    $email = mysqli_real_escape_string($mysqli, $email);
    $res = doQueryInDatabase("SELECT id, email, name, age, gender, password FROM users281 WHERE email = '$email' LIMIT 1");

    if ($res->num_rows == 0)
        returnErrorLoginFailed();

    $row = $res->fetch_assoc();
    $passwordHash = $row['password'];

    if (password_verify($password, $passwordHash)) {
    	$tokenInfo = generateTokenForUser($row['id']);
    	$tokenInfo['id'] = $row['id'];
    	$tokenInfo['name'] = $row['name'];
    	$tokenInfo['email'] = $row['email'];
    	$tokenInfo['age'] = $row['age'];
    	$tokenInfo['gender'] = $row['gender'];
    	$tokenInfo['avatarFilename'] =  $row['avatarFilename'];

    	return $tokenInfo;
    }
    returnErrorLoginFailed();
}


function isTokenExpired($tokenExpiration){
	return $tokenExpiration < strtotime('+0 seconds');
}

function register($email, $password, $name, $age, $gender){
	global $mysqli;
	$email = mysqli_real_escape_string($mysqli, $email);
	$password = mysqli_real_escape_string($mysqli, $password);
	$name = mysqli_real_escape_string($mysqli, $name);

	//$id = newGUID();
	$created_datetime = getDatetimeNowString();
	$passwordHash = password_hash($password, PASSWORD_DEFAULT);

    $res = doQueryInDatabase("INSERT INTO users281 (email, password, name, age, gender, created_at) VALUES ('$email', '$passwordHash', '$name', $age, $gender, Now())");

    $userObj = getUserObjFromEmail($email);

	$tokenInfo = generateTokenForUser($userObj["id"]);
	$result = array_merge($userObj, $tokenInfo);

	return $result;
}

function addAvatarFilenameToDatabase($userId, $avatarFilename) {
	global $mysqli;

    $res = doQueryInDatabase("UPDATE users281 SET avatar_filename = '$avatarFilename' WHERE id = '$userId'");

	return $res;
}

function getAvatarFilename($userId) {
	global $mysqli;
    $email = mysqli_real_escape_string($mysqli, $userId);
    $res = doQueryInDatabase("SELECT avatar_filename FROM users281 WHERE id = '$userId' LIMIT 1");
    if ($res->num_rows == 0)
        return null;

    $row = $res->fetch_assoc();
    if (isset($row["avatar_filename"])) {
    	return $row["avatar_filename"];
    }

    return null;
}

function getUserObjFromEmail($email) {
	global $mysqli;
    $email = mysqli_real_escape_string($mysqli, $email);
    $res = doQueryInDatabase("SELECT id, name, email, age, gender, avatar_filename FROM users281 WHERE email = '$email' LIMIT 1");
    if ($res->num_rows == 0)
        return null;

    $row = $res->fetch_assoc();

    return $row;
}

function getUserObjFromToken($token) {
	global $mysqli;
    $token = mysqli_real_escape_string($mysqli, $token);

    $res = doQueryInDatabase("SELECT id, name, email, age, gender, token, avatar_filename FROM users281 WHERE token = '$token' LIMIT 1");

    if ($res->num_rows == 0)
        return null;

    $row = $res->fetch_assoc();

    return $row;
}


function validateUserToken($token){
	$userObj = getUserObjFromToken($token);

	if ($userObj == null)
		return false;

	if (isTokenExpired($token))
		return $userObj;

	return false;
}




// - - - - - - - - - - - - -
// Aux functions



function getDatetimeNowString(){
	//return date(DATE_ATOM);
    return date('Y-m-d H:i:s');
}



function checkAuthorization($onlyCheckAPIKey = false) {
	if (!isset($_REQUEST["apiKey"]) || $_REQUEST["apiKey"] !== API_KEY )
		returnErrorNotAuthenticated("Wrong API Key");

	if ($onlyCheckAPIKey)
		return true;

	if (!isset($_REQUEST["token"]))
		returnErrorNotAuthenticated("Missing User Token");

	$userObj = validateUserToken($_REQUEST["token"]);
	if ($userObj== false)
		returnErrorNotAuthenticated("Invalid User Token");

	return $userObj;
}




//
// exmaple of use:
// $inputs = getAndCheckParams(array(
// 	array("key" => "filename", "type" => "string", "required" => true),
// 	array("key" => "contents", "type" => "string", "required" => false),
// 	array("key" => "fileObject", "type" => "file",  "required" => false),
// ));
// http://php.net/manual/en/function.gettype.php   (string, integer, boolean, ...)
function getAndcheckParams($list) {
	$params = array();
	foreach ($list as &$param) {
		$key = $param['key'];
		$type = $param['type'];
		$required = $param['required'];

		$origin = $_REQUEST;
		if ($type == "file") {
			$origin = $_FILES;
			$type = "array";
		}

		if ($required && !isset($origin[$key]) )
			returnErrorRequiredParams("Missing Required Param '$key'");

		if (isset($origin[$key])) {
			$value = $origin[$key];

			if ($type === "boolean")
			 	$value = (boolean) $value;

			 if ($type === "integer")
			 	$value = (integer) $value;

			if (gettype($value) != $type)
				returnErrorRequiredParams("Wrong type for key '$key'");

			if ($required && $type == "string" && empty($value))
				returnErrorRequiredParams("Missing");

			$params[$key] = $value;
	 	}
	}
	unset($param);

	return $params;
}



// - - - - - - - - - - - - -
// Return Errors

function returnErrorRequiredParams($errorMsgDetail = null){
    returnError(1, "Missing/Invalid params", $errorMsgDetail);
}

function returnErrorLoginFailed($errorMsgDetail = null){
    returnError(2, "Login failed. Username or Password invalid.", $errorMsgDetail);
}

function returnErrorAccountAlreadyExist($errorMsgDetail = null){
    returnError(3, "Registration failed. Account already exist.", $errorMsgDetail);
}

function returnErrorNotAuthenticated($errorMsgDetail){
    returnError(4, "You are not logged in. Please sign in.", $errorMsgDetail);
}

function returnErrorAWS($service, $errorMsgDetail){
	returnError(5, "An error ocurred communicating with AWS $service", $errorMsgDetail);
}

function returnErrorDatabase(){
	global $mysqli;
	returnError(6, "An error occurred communicating with the database", $mysqli->error);
}

function returnErrorFileAlreadyExist(){
	global $mysqli;
	returnError(7, "An object with that name already exist. Please choose another name.");
}

function returnError($code, $msg, $msgDetail = null){
	$ret = new StdClass();
	$ret->errorCode = $code;
	$ret->errorMessage = $msg;
	$ret->errorMessageDetail = $msgDetail;
    returnJSON($ret);
}

// - - - - - - - - - - - - -
// Return Json

function returnJSON($obj) {
    header("Content-type: application/json");
    $out = json_encode($obj, JSON_PRETTY_PRINT);
    print $out;
    exit;
}


?>
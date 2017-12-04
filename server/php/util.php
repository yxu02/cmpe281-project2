<?php
function returnJSON($obj) {
    header("Content-type: application/json");
    $out = json_encode($obj, JSON_PRETTY_PRINT);
    echo $out;
    exit;
}

function returnError($code, $msg, $msgDetail = null){
	$ret = new StdClass();
	$ret->errorCode = $code;
	$ret->errorMessage = $msg;
	$ret->errorMessageDetail = $msgDetail;
    returnJSON($ret);
}

function dbError($error){
	returnError(6, "An error occurred communicating with the database", $error);
}




// - - - - - - - - - - - - - -
// AWS ElastiCache Functions - Added by Renato


function getRedisClient() {
	$redisClient = new Redis();
	$redisClient->connect("XXXXXXX.XXXXXXX.XX.0001.usw1.cache.amazonaws.com", 6379);

	return $redisClient;
}

function getFromRedis($key) {
	$valueJSON = json_encode($value);

	$redisClient = getRedisClient();
	$jsonValue = $redisClient->get($key);

	if ($jsonValue != null) {
		$value = json_decode($jsonValue);
		return $value;
	}

	return null;
}

function saveInRedis($key, $value) {
	$valueJSON = json_encode($value);

	$redisClient = getRedisClient();
	$redisClient->set($key, $valueJSON, 10);
}




?>
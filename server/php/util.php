<?
function myprint($str){
	echo "<p>";
	echo "------------------";
	echo "<p>";
	echo $str;
	echo "<p>";
	echo "------------------";
	echo "<p>";		
}

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


?>
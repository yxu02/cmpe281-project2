<?php
// created by Renato

require 'functions.php';

checkAuthorization(true);

// Checking and validating params
$inputs = getAndCheckParams(array(
	array("key" => "email", "type" => "string", "required" => true),
	array("key" => "password", "type" => "string", "required" => true),
	array("key" => "name", "type" => "string", "required" => true),
	array("key" => "age", "type" => "integer", "required" => false),
	array("key" => "gender", "type" => "integer", "required" => false),
));

$email = $inputs["email"];
$password = $inputs["password"];
$name = $inputs["name"];
$age = isset($inputs["age"])? $inputs["age"]: "NULL";
$gender = isset($inputs["gender"])? $inputs["gender"]: "NULL";


if (getUserObjFromEmail($email))
	return returnErrorAccountAlreadyExist();

return returnJSON(register($email, $password, $name, $age, $gender));


?>
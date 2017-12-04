<?php
// created by Renato

require 'functions.php';

checkAuthorization(true);

// Checking and validating params
$inputs = getAndCheckParams(array(
	array("key" => "email", "type" => "string", "required" => true),
	array("key" => "password", "type" => "string", "required" => true),
));
$email = $inputs["email"];
$password = $inputs["password"];


return returnJSON(login($email, $password))


?>
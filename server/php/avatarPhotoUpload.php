<?php
// Include the SDK using the Composer autoloader
require 'aws.phar';

require 'functions.php';


define("MAX_FILE_SIZE", 10*1024*1024); // 10mb

// checking authorization keys
$userObj = checkAuthorization(true);

// Checking and validating params
$inputs = getAndCheckParams(array(
	array("key" => "fileObject", "type" => "file",  "required" => true),
	array("key" => "userid", "type" => "string",  "required" => true),
));

$fileObject = $inputs["fileObject"];
$userid = $inputs["userid"];


if (!isset($fileObject) )
	returnErrorRequiredParams("Contents or File expected");

if (isset($fileObject) && $fileObject['size'] > MAX_FILE_SIZE)
	returnErrorRequiredParams("File size is too big.");



// Executing action

$filename = getAvatarFilename($userid);
if ($filename == null) {
	$filename = newGUID() . ".jpg";
}

$avatarURL = awsPutObjectFromFile($filename, $fileObject['tmp_name']);
addAvatarFilenameToDatabase($userid, $filename);


returnJSON(["avatarFilename" => $filename]);






// - - - - - - - - - - - - -
// AWS info - Customize your settings here!






function awsPutObjectFromFile($filename, $filePath){
	$awsSharedConfig = [
    	'region'  => 'us-west-1',
    	'version' => 'latest'
	];

	$awsSDK = new Aws\Sdk($awsSharedConfig); // creates an AWS SDK object with the shared configuration
	$s3Client = $awsSDK->createS3();  // creates an AWS SDK S3 client


	try {
		$result = $s3Client->putObject([
		    'Bucket' => "cmpe281-project2",
		    'Key' => $filename,
		    'SourceFile' => $filePath,
		]);
	} catch (Exception $e) {
	    returnErrorAWS("S3", $e->getMessage());
	}

	//return $result->toArray();
	return "https://www.cmpe281.site/$filename";
}





?>
<?php
//created by Renato

require 'aws_keys.php';
require 'aws.phar';

require 'functions.php';

checkAuthorization(true);



// Checking and validating params
$inputs = getAndCheckParams(array(
	array("key" => "fileObject", "type" => "file",  "required" => true),
));
$fileObject = $inputs["fileObject"];


// getting the file path
$path = $fileObject['tmp_name'];



// creating AWS Reko client
$awsRegion = 'us-west-2';

$awsSharedConfig = [
    'region'  => $awsRegion,
    'version' => 'latest'
];
$awsSDK = new Aws\Sdk($awsSharedConfig); // creates an AWS SDK object with the shared configuration

$awsReko = $awsSDK->createRekognition();


// calling AWS Reko API
$result = $awsReko->detectLabels([
    'Image' => [ // REQUIRED
        'Bytes' => file_get_contents($path),
    ],
    'MaxLabels' => 10,
    'MinConfidence' => 50,
]);


returnJSON($result["Labels"]);


?>
<?php
?>
<!doctype html>
<html>
<body>

<h1>Mindful Nutrition</h1>
<?

// Include the SDK using the Composer autoloader
require 'aws.phar';
require 'aws_keys.php';
require 'dbconf.php';
include 'userfoods.php';

$useremail = 'nutracker.test@gmail.com';
$userid = '';

	echo "<table>";
			echo "<tr>";
					echo "<td>"; 
						echo "id";
					echo "</td>"; 
					echo "<td>"; 
						echo "user_id";
					echo "</td>"; 
					echo "<td>"; 
						echo "food_id";
					echo "</td>"; 				
					echo "<td>"; 
						echo "food_name";
					echo "</td>"; 
					echo "<td>"; 
						echo "meal_id";
					echo "</td>"; 				
					echo "<td>"; 
						echo "count";
					echo "</td>"; 				
					echo "<td>"; 
						echo "unit";
					echo "</td>"; 				
					echo "<td>"; 
						echo "created_at";
					echo "</td>"; 
			echo "</tr>";


	if ($result = allUserActivity($useremail) ) {
		echo "Number of rows returned : " . $result->num_rows;
		echo "<p>";
		$userid = $row[1];

			while ($row = $result->fetch_row()) {
			echo "<tr>";
					echo "<td>"; 
						echo $row[0];
					echo "</td>"; 
					echo "<td>"; 
						echo $row[1];
					echo "</td>"; 
					echo "<td>"; 
						echo $row[2];
					echo "</td>";
					echo "<td>"; 
						echo $row[3];
					echo "</td>"; 	
					echo "<td>"; 
						echo $row[4];
					echo "</td>"; 	
					echo "<td>"; 
						echo $row[5];
					echo "</td>"; 	
					echo "<td>"; 
						echo $row[6];
					echo "</td>"; 	
					echo "<td>"; 
						echo $row[7];
					echo "</td>"; 	
			echo "</tr>";
			}
	} else {
		echo ">> query returns no rows";
	}
	echo "</table>";	
?>
<p>
<?php
//Hardcoded for testing
$userid = 1;

if (isset($_POST['food0']) && isset($_POST['food2'])) {
//    $result = addNumbers(intval($_POST['number1']), intval($_POST['number2']));
	$food[0] = $_POST['food0'];
	$food[1] = $_POST['food1'];
	$food[2] = $_POST['food2'];
	$food[3] = $_POST['food3'];

    $res = enterFood($userid, $food);
}
?>
<html>
<body>
    <?php if (isset($res)) { ?>
        <h1> Result: <?php echo $res ?></h1>
    <?php } ?>
    <h1> USER ID : <?php echo $userid ?></h1>
    <form action="" method="post">
    <p>Food Name: <input type="text" name="food0" /></p>
    <p>Meal Id: <input type="text" name="food1" /></p>
    <p>Count: <input type="text" name="food2" /></p>
    <p>Unit: <input type="text" name="food3" /></p>
    <p><input type="submit"/></p>

</p>

</body>
</html>

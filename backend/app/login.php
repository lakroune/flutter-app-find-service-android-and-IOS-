<?php 
include "se connecter.php";
//connecting to database server

$password = $_POST["password"]; 
$email = $_POST["email"]; 

$sql ="SELECT * FROM user WHERE email ='$email' and password= '$password' ";
$res = mysqli_query($link, $sql);

if($res->num_rows == 1 )
	echo json_encode([ $res->fetch_assoc()]);
else 
	echo json_encode("error");

mysqli_close($link);
?>
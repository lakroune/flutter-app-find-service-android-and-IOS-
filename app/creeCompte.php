<?php 
include "se connecter.php";
$nomUser = $_POST["nomUser"]; 
$prenomUser =  $_POST["prenomUser"];
$email =  $_POST["email"]; 
$password =  $_POST["password"]; 

$sql ="INSERT INTO user (nomUser, prenomUser, email, password) VALUES
 ('$nomUser', '$prenomUser', '$email', '$password')";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');

mysqli_close($link);
?>

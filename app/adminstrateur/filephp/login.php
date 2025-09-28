<?php 
include "se connecter.php";
//connecting to database server

$password = $_POST["password"]; 
$email = $_POST["email"]; 

$sql ="SELECT * FROM user WHERE email ='$email' and password= '$password'  and typeUser='admin'  " ;
$res = mysqli_query($link, $sql);

if($res->num_rows == 1 ){
	echo json_encode([ $res->fetch_assoc()]);
header("location:../accueil.html");
}
else 
	header("location:../login.php");

mysqli_close($link);
?>

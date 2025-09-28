<?php 
include "se connecter.php";

$idUser = $_POST["idUser"]; 

$sql ="DELETE FROM user WHERE idUser =$idUser ";
$res = mysqli_query($link, $sql);
if($res)
	echo json_encode("success");
else 
	echo json_encode("error");

mysqli_close($link);
?>
<?php 

include "se connecter.php";

//connecting to database server
$idUser = $_POST["idUser"]; 
$sql ="UPDATE user SET typeUser='artisan' WHERE idUser=$idUser ";
$res = mysqli_query($link, $sql);
if($res) echo json_encode('success');
else echo json_encode('error');
mysqli_close($link);
?>

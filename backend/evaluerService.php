<?php 
include "se connecter.php";
$comantaire= $_POST["comantaire"];
$idClient = $_POST["idClient"]; 
$idService = $_POST["idService"]; 
$nombreEtoile = $_POST["nombreEtoile"]; 

$sql ="INSERT INTO evaluer (idClient,idService,nombreEtoile,comantaire) 
VALUES ($idClient,$idService,$nombreEtoile, '$comantaire' )";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');
mysqli_close($link);
?>

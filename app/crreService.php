<?php 
include "se connecter.php";

$nomService = $_POST["nomService"]; 
$prix =  $_POST["prix"];
$idArtisan =  $_POST["idArtisan"]; 
$idCategorie =  $_POST["idCategorie"]; 

$sql ="INSERT INTO service (nomService, datePub, prix, idArtisan, idCategorie) VALUES ('$nomService', now(), $prix, $idArtisan, $idCategorie) ";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');

mysqli_close($link);
?>

<?php 
include "se connecter.php";
$idClient = $_POST["idClient"]; 
$idService = $_POST["idService"]; 
$message = $_POST["message"]; 
$sqlGetIdArtiasn="SELECT * FROM service WHERE idService=$idService";
$resGetIdArtisan = mysqli_query($link, $sqlGetIdArtiasn);

$linge = $resGetIdArtisan->fetch_assoc() ;
$idArtisan=$linge["idArtisan"];		

$sql ="INSERT INTO message (idUser1,idService, idUser2,message,dateMessage) VALUES ($idClient,$idService, $idService,'$message',now() )";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');
mysqli_close($link);
?>

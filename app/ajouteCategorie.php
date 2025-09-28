<?php 
include "se connecter.php";
$nomCategorie = $_POST["nomCategorie"]; 

$sql ="INSERT INTO categorie (nomCategorie) VALUES ('$nomCategorie')";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');

mysqli_close($link);
?>

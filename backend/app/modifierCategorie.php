<?php 
include "se connecter.php";
//connecting to database server
$nomCategorie = $_POST["nomCategorie"]; 
$idCategorie = $_POST["idCategorie"]; 

$sql ="UPDATE categorie SET nomCategorie='$nomCategorie' WHERE idCategorie=$idCategorie";
$res = mysqli_query($link, $sql);
if($res) echo json_encode('success');
else echo json_encode('error');
mysqli_close($link);
?>

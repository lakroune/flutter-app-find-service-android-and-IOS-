<?php 
include "se connecter.php";

$idCategorie = $_POST["idCategorie"]; 

$sql ="DELETE FROM categorie  WHERE idCategorie='$idCategorie' ";
$res = mysqli_query($link, $sql);

if($res) echo json_encode('success');
else echo json_encode('error');

mysqli_close($link);
?>

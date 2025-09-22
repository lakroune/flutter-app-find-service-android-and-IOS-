<?php 
include "se connecter.php";
$requete = $_POST["requete"]; 

$sql ="$requete";
$res = mysqli_query($link, $sql);
if($res) echo json_encode('success');
else echo json_encode('error');

mysqli_close($link);
?>

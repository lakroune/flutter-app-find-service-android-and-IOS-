<?php 
include "se connecter.php";

 	 $idUser = $_POST["idUser"]; 
	 $imagename=$_POST['nom'];
     $image=base64_decode($_POST['image']);
     $numTele=$_POST["numTele"];
     $ville=$_POST["ville"];

     file_put_contents("images//".$imagename, $image);
	$sql =" UPDATE user SET photo= '$imagename' , ville= '$ville' , numTele = '$numTele' , etat ='en attente' WHERE idUser=$idUser ";
	$res = mysqli_query($link, $sql);

		if($res) echo json_encode('success');
		else echo json_encode('error');

mysqli_close($link);
?>

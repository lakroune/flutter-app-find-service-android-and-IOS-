<?php 
include "se connecter.php";
 	 $idUser = $_POST["idUser"]; 
	 $imagename=$_POST['nom'];
     $image=base64_decode($_POST['image']);
        file_put_contents("images//".$imagename, $image);
	$sql =" UPDATE user SET photo= '$imagename' WHERE idUser=$idUser ";
	$res = mysqli_query($link, $sql);

		if($res) echo json_encode('success');
		else echo json_encode('error');

mysqli_close($link);
?>

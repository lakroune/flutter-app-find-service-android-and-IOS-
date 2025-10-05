<?php 
include "se connecter.php";

 	 $idUser =  $_POST["idUser"]; 

    file_put_contents("images//".$imagename, $image);
	$sql ="SELECT etat FROM user  WHERE idUser=$idUser ";
	
	$res = mysqli_query($link, $sql);


$deja=array();
		if($res->num_rows>0)
			$data_base[]=$res->fetch_assoc() ;

		if($res) echo json_encode($data_base);
		else echo json_encode('error');

mysqli_close($link);
?>


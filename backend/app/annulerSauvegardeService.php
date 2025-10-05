
<?php

	include "se connecter.php";

	$idService = $_POST['idService'];
	$idClient = $_POST['idClient'];

	$sql="DELETE FROM  enregistrie WHERE idService=$idService AND idClient=$idClient ";
	$res = mysqli_query($link,$sql);

	if($res) echo json_encode("succus");
	else echo json_encode("error")  ;



?>
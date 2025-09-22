<?php 
include "se connecter.php";
$requte=$_POST['requete'];
$sql ="$requete";
$res = mysqli_query($link, $sql);

$data_base=array();

if($res->num_rows >0 ){
	while ($linge = $res->fetch_assoc()) 
			$data_base[]=$linge;
	echo json_encode($data_base);
}
else 
	echo json_encode("error");

mysqli_close($link);
?>
 
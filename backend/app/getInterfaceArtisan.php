<?php 
include "se connecter.php";
$idUser= 3;//$_POST['idUser'];
$sql ="SELECT   * FROM service s inner join  message m inner join user u on u.idUser=m.idUser1 and s.idArtisan =m.idUser2 and s.idArtisan=$idUser group by m.idMessage  ";
$res = mysqli_query($link, $sql);

if($res->num_rows >0 ){
	while ($linge = $res->fetch_assoc()) {
			$data_base[]=$linge;
	}
	echo json_encode($data_base);
}
else 
	echo json_encode("error");

mysqli_close($link);
?>

<?php 
include "se connecter.php";
$idUser= $_POST['idUser'];
$sql ="SELECT s.idService,s.nomService,s.datePub,s.prix,s.idArtisan,s.idCategorie,s.etat FROM message m inner join service s on s.idService=m.idService and m.idUser1=$idUser  group by s.idService ";
$res = mysqli_query($link, $sql);

if($res->num_rows >0 ){
	while ($linge = $res->fetch_assoc()) {
		$idSer=$linge["idService"];
		$sql1  ="SELECT * FROM image WHERE idService=$idSer";
		$res1=mysqli_query($link,$sql1);
		$images=array();
		if($res1->num_rows>0)
			while($linge1=$res1->fetch_assoc())
				$images[]=$linge1;
			$linge["images"]=$images;
			$data_base[]=$linge;


	}
	echo json_encode($data_base);
}
else 
	echo json_encode("error");

mysqli_close($link);
?>

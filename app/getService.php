<?php 
include "se connecter.php";
$idUser= $_POST["idUser"];
$sql ="SELECT s.idService,s.nomService,s.datePub,s.prix,s.idArtisan,s.idCategorie,s.etat, Avg(e.nombreEtoile)  as moyEtoile FROM service s inner join evaluer e on s.idService=e.idService  group by s.idService ";
$res = mysqli_query($link, $sql);

$data_base=array();
if($res->num_rows >0 ){
	while ($linge = $res->fetch_assoc()) {
		$idSer=$linge["idService"];
		$sql1  ="SELECT * FROM image WHERE idService=$idSer";
		$res1=mysqli_query($link,$sql1);
		$images=array();
		if($res1->num_rows>0)
			while($linge1=$res1->fetch_assoc())
				$images[]=$linge1;
		$sqlSave  ="   SELECT CASE WHEN 0 < (SELECT count(*) FROM enregistrie where idService=$idSer  and idClient=$idUser ) THEN 'oui' ELSE 'non' end as 'etat'  ";
		$resSave=mysqli_query($link,$sqlSave);
		$lingeSave=$resSave->fetch_assoc();
			$linge["images"]=$images;
			$linge["save"]=$lingeSave["etat"];
			$data_base[]=$linge;
	}
	echo json_encode($data_base);
}
else 
	echo json_encode("error");

mysqli_close($link);
?>

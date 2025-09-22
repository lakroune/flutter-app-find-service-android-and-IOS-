<?php 
include "se connecter.php";
//connecting to database server
$idService=     $_POST["idService"];
$idClient=   $_POST["idClient"];
$sql ="SELECT * FROM service WHERE idService=$idService ";
$res = mysqli_query($link, $sql);
$data_base=array();
if($res->num_rows >0 ){
	$linge = $res->fetch_assoc();
		$sql1  ="SELECT * FROM image WHERE idService=$idService";
		$res1=mysqli_query($link,$sql1);
		$images=array();
		if($res1->num_rows>0)
			while($linge1=$res1->fetch_assoc()){
				$images[]=$linge1;
			}
			$linge["images"]=$images;
			$data_base[]=$linge;
$idUser=$linge["idArtisan"];
$sql ="SELECT * FROM user WHERE idUser=$idUser ";
$res = mysqli_query($link, $sql);
$data_base[] = $res->fetch_assoc();
$idCategorie=$linge["idCategorie"];

$sql ="SELECT * FROM categorie WHERE idCategorie=$idCategorie ";
$res = mysqli_query($link, $sql);
$data_base[] = $res->fetch_assoc();

$sql =" SELECT CASE WHEN 0< (SELECT u.idUser FROM user u inner join evaluer e on u.idUser=e.idClient and u.idUser=$idClient  and e.idService=$idService) THEN 'oui' ELSE 'non' end as 'etat' ";
$res = mysqli_query($link, $sql);
$data_base[] = $res->fetch_assoc();

$sql =" SELECT CASE WHEN 0< (SELECT sum(nombreEtoile)  FROM evaluer WHERE idService=$idService)   THEN  (SELECT sum(nombreEtoile)  FROM evaluer WHERE idService=$idService) ELSE '1' end as 'nombreTotal' ";
$res = mysqli_query($link, $sql);
$data_base[] = $res->fetch_assoc();
$sql ="SELECT e.comantaire,e.idClient,e.nombreEtoile,u.nomUser,u.prenomUser,u.photo FROM evaluer e inner join user u on e.idService=$idService  and e.idClient=u.idUser ";
$res = mysqli_query($link, $sql);
if($res->num_rows>0)
while ($linge=$res->fetch_assoc()) 
$data_base[] = $linge;


	echo json_encode($data_base);    
}
else 
	echo json_encode("error");

mysqli_close($link);
?>

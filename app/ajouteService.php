
<?php
include "se connecter.php";


    $imagename1=$_POST['nom1'];
    $image1=base64_decode($_POST['image1']);  

     $imagename2=$_POST['nom2'];
    $image2=base64_decode($_POST['image2']);  

     $imagename3=$_POST['nom3'];
    $image3=base64_decode($_POST['image3']);  

     $imagename4=$_POST['nom4'];
    $image4=base64_decode($_POST['image4']);    

    $nomService =  $_POST["nomService"]; 
    $prix =  $_POST["prix"];
    $idArtisan =  $_POST["idArtisan"]; 
    $idCategorie =  $_POST["idCategorie"]; 

$sql ="INSERT INTO service (nomService, datePub, prix, idArtisan, idCategorie) VALUES ('$nomService', now(), $prix, $idArtisan, $idCategorie) ";

            $res = mysqli_query($conn, $sql);
            if($res){
            $sql="SELECT max(idService) FROM service WHERE idArtisan=$idArtisan " ;
            $res = $conn->query($sql);   
            $table=$res->fetch_assoc() ;
           
            $idService= $table['max(idService)'];

            if($imagename1!=""){
            file_put_contents("images//".$imagename1, $image1);
            $sql="insert into image(idService,source)values('$idService','$imagename1')";
            $res = mysqli_query($conn, $sql);
            }
             if($imagename2!=""){
            file_put_contents("images//".$imagename2, $image2);
            $sql="insert into image(idService,source)values('$idService','$imagename2')";
            $res = mysqli_query($conn, $sql);
            }
             if($imagename3!=""){
            file_put_contents("images//".$imagename3, $image3);
            $sql="insert into image(idService,source)values('$idService','$imagename3')";
            $res = mysqli_query($conn, $sql);
            }
             if($imagename4!=""){
            file_put_contents("images//".$imagename4, $image4);
            $sql="insert into image(idService,source)values('$idService','$imagename4')";
            $res = mysqli_query($conn, $sql);
            }

           if($res)  echo json_encode("ok");
             else echo json_encode("no");
          }
           else echo json_encode("no");

 ?>
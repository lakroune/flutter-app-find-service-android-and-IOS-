<?php 
include "se connecter.php";
$nomService = $_POST["nomService"]; 

$sql ="SELECT * FROM sevrvice WHERE nomService like '$nomService' ";
$res = mysqli_query($link, $sql);
 $db_data = array();
 if($res->num_rows > 0){
        while($row = $res->fetch_assoc()){
            $db_data[] = $row;
        }
	echo json_encode($db_data);
mysqli_close($link);
?>



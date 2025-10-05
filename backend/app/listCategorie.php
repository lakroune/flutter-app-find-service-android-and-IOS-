<?php 
include "se connecter.php";

 $db_data = array();

$sql ="SELECT * FROM categorie  ";
$res = mysqli_query($link, $sql);
 $db_data = array();
 if($res->num_rows > 0){
        while($row = $res->fetch_assoc()){
            $db_data[] = $row; 
        }

	echo json_encode($db_data);
}
else
echo json_encode("error");

mysqli_close($link);

?>



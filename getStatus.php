<?php
include('config.php');

   $result = $table->exec($trapdata);
   if(!$result){
       $table->lastErrorMsg();
   } 
 
   $query = "SELECT * FROM trapdata";
   $ret = $table->query($query);


while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
      		echo   $row['fqdn']." | ".$row['status']." | ".$row['newtime']." | ".$row['oldstatus']." | ".$row['oldtime']."\n";
     }

if($ret->fetchArray(SQLITE3_ASSOC) == 0){
      echo "FALSE";
   }


   $table->close();
?>






<?php
   include('config.php');
   $result = $table->exec($manager);
   if(!$result){
       $table->lastErrorMsg();
   } 
 $sql =<<<EOF
	INSERT INTO manager (ip,port,community) VALUES ("$_GET[ip]",$_GET[port],"$_GET[community]");
EOF;
   $answer = $table->exec($sql);
   if(!$answer){
      echo "FALSE";
   }else{
	echo "OK";
}
	
   $table->close();
?>

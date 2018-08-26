<?php
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('nasir.db');
      }
   }
   $table = new MyDB();
   $trapdata =<<<EOF
      CREATE TABLE IF NOT EXISTS trapdata(fqdn TEXT NOT NULL,status INT NOT NULL,newtime INT NOT NULL,oldstatus INT,oldtime INT);
EOF;
$manager =<<<EOF
      CREATE TABLE IF NOT EXISTS manager(ip VARCHAR NOT NULL,port INT NOT NULL,community STRING NOT NULL);

EOF;

   ?>

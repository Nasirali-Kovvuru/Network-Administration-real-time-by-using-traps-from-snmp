In this project there are 6 scripts to work with, those are " config.php, getStatus.php, getTrapR.php, setTrapR.php, Trapd.conf, Traphandler"

config.php    -> this file is used to create a database with 2 tables as per our requirement we can change number of tables.

setTrapR.php  -> this file is used to set the device(just for lab experimentation in real time this will be replaced with real network elements.) to send traps

getStatus.php -> this file is used to fetch the details in the trapdata table from the database. 

Traphandler   -> this script consist of all the logic how to handle trap messages with respect to their oid and trap details.

Trapd.conf    -> to change configuration of the daemon we are working with, in our case we are working on 50162 port and we have specified where to go if trap received.

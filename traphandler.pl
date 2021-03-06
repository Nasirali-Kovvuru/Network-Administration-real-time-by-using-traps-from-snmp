#!/usr/bin/perl
use Net::SNMP;
use DBI;
use NetSNMP::TrapReceiver;
my $driver   = "SQLite"; 
my $database = "nasir.db";
my $bddriver = "DBI:$driver:$database";
my $dbconnect = DBI->connect($bddriver, { RaiseError => 1 }) 
   or die $DBI::errstr;
print "Opened database successfully\n";
my $datacre = qq(CREATE TABLE IF NOT EXISTS trapdata(fqdn TEXT NOT NULL,status INT NOT NULL,newtime INT NOT NULL,oldstatus INT,oldtime INT););
my $datastat = $dbconnect->do($datacre);
if($datastat < 0) {
   print $DBI::errstr;
} else {
   print "Table created successfully\n";
}
my $fqdn;
my $divst;
my $time;
sub my_receiver {
     foreach my $x (@{$_[1]}) { 
           
		if ("$x->[0]" eq ".1.3.6.1.4.1.41717.10.1"){
		 	$fqdn =  $x->[1];
                        $time = time();	
		}
		elsif ("$x->[0]" eq ".1.3.6.1.4.1.41717.10.2"){
			$divst = $x->[1];
		}      
	}
     $fqdn =~ s/\"//gs;
     my $val=0;
     $datacre = qq(SELECT fqdn,status,newtime,oldstatus,oldtime from trapdata;);
     my $exec = $dbconnect->prepare( $datacre );
     $datastat = $exec->execute() or die $DBI::errstr;
     my @a;
     while (my @row = $exec->fetchrow_array()){
       push @a ,$row[0];
      }
     my $size = @a;
     if($size>0){
	$datacre = qq(SELECT fqdn,status,newtime,oldstatus,oldtime from trapdata;);
	my $exec = $dbconnect->prepare( $datacre );
	$datastat = $exec->execute() or die $DBI::errstr;
        while(my @row =$exec->fetchrow_array()) {
	
	  if ($row[0] eq $fqdn){
		
		$old_time = $row[2];
		$datacre = qq(UPDATE trapdata set status="$divst", newtime="$time", oldstatus="$row[1]", oldtime="$old_time" where fqdn="$row[0]";);
		$datastat = $dbconnect->do($datacre) or die $DBI::errstr;
		$val = $val+1;
	    }
	 
	 }
      }
      else
         { 
	$datacre = qq(INSERT INTO trapdata (fqdn,status,newtime,oldstatus,oldtime)
               VALUES ("$fqdn","$divst","$time","$divst","$time"));
		$datastat = $dbconnect->do($datacre) or die $DBI::errstr;
		$val = $val+1;
        }
      if($val==0){ 
               $datacre = qq(INSERT INTO trapdata (fqdn,status,newtime,oldstatus,oldtime)
               VALUES ("$fqdn","$divst","$time","$divst","$time"));
		$datastat = $dbconnect->do($datacre) or die $DBI::errstr;
		$val = $val+1;
}




     $datacre = qq(SELECT fqdn,status,newtime,oldstatus,oldtime from trapdata;);
     $exec = $dbconnect->prepare( $datacre );
     $datastat = $exec->execute() or die $DBI::errstr;


     my @danger=();
     my @fail=();
     my $k=0;
     while(my @row =$exec->fetchrow_array()) { 
	if ($row[1]==3){
		push @fail,('.1.3.6.1.4.1.41717.20.1', OCTET_STRING,$row[0], '.1.3.6.1.4.1.41717.20.2',TIMETICKS,$row[2], '.1.3.6.1.4.1.41717.20.3',INTEGER,$row[3],'.1.3.6.1.4.1.41717.20.4',TIMETICKS,$row[4]);
	}

	elsif ($row[1]==2 && $row[3]!=3){
		push @danger,('.1.3.6.1.4.1.41717.30.'.(($k*4)+1), OCTET_STRING,$row[0], '.1.3.6.1.4.1.41717.30.'.(($k*4)+2),TIMETICKS,$row[2], '.1.3.6.1.4.1.41717.30.'.(($k*4)+3),INTEGER,$row[3],'.1.3.6.1.4.1.41717.30.'.(($k*4)+4),TIMETICKS,$row[4]);
	$k = $k+1;

				}
		

}

push @fail,@danger;
$datacre = qq(SELECT * FROM manager;);
$exec = $dbconnect->prepare( $datacre );
$datastat = $exec->execute() or die $DBI::errstr;
@row =$exec->fetchrow_array();
my ($session, $error) = Net::SNMP->session(
   -hostname  => $row[0],
   -community => $row[2],
   -port      => $row[1],      
);

$result = $session->trap(-varbindlist  => \@fail); 
}

NetSNMP::TrapReceiver::register("all", \&my_receiver) || 
     warn "failed to register our perl trap handler\n";
    print STDERR "Loaded the example perl snmptrapd handler\n";




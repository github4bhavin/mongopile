#!/usr/bin/perl

use Test::More;

use_ok('DBI');


#__test available drivers

subtest 'SQLite Tests' => sub {
     my $testDB = 'sqliteTest.db';
     my $dbh = DBI->connect ( "dbi:SQLite:dbname=$testDB", "", "",
                              {RaiseError => 0, PrintError => 0});

     SKIP : {
	     skip 'SQLite Connect Error '  unless  ok( $dbh , 'SQLite connect');                         
		 ok( $dbh->do("DROP TABLE IF EXISTS mpTEST"),'initiate test');
		 my @mpTEST = ( 'id INT PRIMARY KEY',
		                'name TEXT',
		              );
		 ok( $dbh->do("CREATE TABLE mpTEST(". join (',', @mpTEST) .")") , 'create table'); 
		 ok( $dbh->do("INSERT INTO mpTEST VALUES(1,'replicaset_t1')"),"insert table");
		 ok( !($dbh->do("INSERT INTO mpTEST VALUES(1,'replicaset_t1,5')")),"fail insert table [should fail]");
		 
		 my $sth = $dbh->selectall_arrayref("describe mpTEST");
		    use Data::Dumper;
		    diag Dumper $sth;
		    
		 ok( $dbh->do("DROP TABLE mpTEST"),"Clean up");		
		 
		 ok ( unlink ($testDB) , 'removed DB'); 
     };
     
   done_testing();
   
};

done_testing();
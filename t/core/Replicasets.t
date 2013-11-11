#!/usr/bin/perl
use Test::More;
use Data::Dumper;

my @_PROJECT_DIR;

BEGIN {

use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR;
   pop @_PROJECT_DIR;
   push @INC , join '/', @_PROJECT_DIR , 'lib';
   push @INC , join '/', @_PROJECT_DIR , 'mongopile';
   push @INC , join '/', @_PROJECT_DIR , 'CORE';
};

my $required_version = 1.0;

SKIP: {

 skip "Required Version ($required_version) not present" , 1 
 unless use_ok('mongopile::CORE::Replicasets' , 
               $required_version );

	my $obj = new_ok('mongopile::CORE::Replicasets');
	#___ METHODS EXIST TEST

	
	map { can_ok( $obj , $_); }
	(
	);
	               
        my $rs_status;
        if ( !($rs_status = $obj->get_replicaset_status_using_rest() ) ) {
           diag $obj->error;
           skip 'no local mongo instance running' , 1 ;
        } 
        ok( $obj->rsname, 'rs name');
        ok( $obj->get_members , 'get members' );
        
  
         
};



done_testing();
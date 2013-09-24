#!/usr/bin/perl

use Test::More;
use Data::Dumper;

use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

my @_PROJECT_DIR;

BEGIN {
   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR;
   pop @_PROJECT_DIR;
   push @INC , join '/', @_PROJECT_DIR , 'lib';
   push @INC , join '/', @_PROJECT_DIR , 'mongopile';
   push @INC , join '/', @_PROJECT_DIR , 'CORE';      
};

use_ok('mongopile::CORE::Replicasets');

my $obj = new_ok('mongopile::CORE::Replicasets');

#___ METHODS EXIST TESt

my @methods = ( 'new',
               'error',
               'rsname',
               'members',
               'get_replicaset_status_using_rest',
             );   

map { can_ok( $obj , $_); } @methods;

#___ FUNCTIONAL TEST
SKIP: {
        my $rs_status;
        if ( !($rs_status = $obj->get_replicaset_status_using_rest() ) ) {
           diag $obj->error;
           skip 'no local mongo instance running' , 1 ;
        } 
        
        ok( $obj->members, 'get members');
		diag Dumper $obj->members;
		
        ok( $obj->rsname, 'rs name');
        diag $obj->rsname;
        diag Dumper $obj;
};

 

done_testing();
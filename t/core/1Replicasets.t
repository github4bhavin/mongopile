#!/usr/bin/perl

use Test::More;

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
   $obj->host('dfprdzwkvdb1.df.jabodo.com');
   $obj->port('28017');

#___ METHODS EXIST TESt

my @methods = ( 'new',
               'get_status',
               'host',
               'port',
               'http',
               'error',
               'rs_data',
               'rs_name',
               'get_members',
               'get_stats_for_member',
             );   

map { can_ok( $obj , $_); } @methods;

#___ FUNCTIONAL TESt
SKIP: {
        my $rs_status;
        if ( !($rs_status = $obj->get_status() ) ) {
           diag $obj->error;
           skip 'no local mongo instance running' , 1 ;
        } 
        
        ok( $obj->get_members(), 'get members');
        ok( $obj->host(), 'host');
        ok( $obj->port(), 'port');
        ok( $obj->http(), 'http');
        ok( !defined($obj->error()), 'error');
        ok( $obj->rs_data(),'rs_data');
        ok( $obj->rs_name(), 'rs_name');
};

 

done_testing();
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

use_ok('mongopile::CORE::Replicasets');

my $obj = new_ok('mongopile::CORE::Replicasets');

#___ METHODS EXIST TESt

my @methods = ( 'new',
               'error',
<<<<<<< HEAD:t/core/1Replicasets.t
               'rs_data',
               'rs_name',
               'get_members',
               'get_stats_for_member',
             );
=======
               'rsname',
               'members',
               'get_replicaset_status_using_rest',
             );   
>>>>>>> cf33a3273ba243b535bb013ba32a31dda7f6e2b1:t/core/Replicasets.t

map { can_ok( $obj , $_); } @methods;

#___ FUNCTIONAL TEST
SKIP: {
        my $rs_status;
        if ( !($rs_status = $obj->get_replicaset_status_using_rest() ) ) {
           diag $obj->error;
           skip 'no local mongo instance running' , 1 ;
<<<<<<< HEAD:t/core/1Replicasets.t
        }

        ok( $obj->get_members(), 'get members');
        ok( $obj->host(), 'host');
        ok( $obj->port(), 'port');
        ok( $obj->http(), 'http');
        ok( !defined($obj->error()), 'error');
        ok( $obj->rs_data(),'rs_data');
        ok( $obj->rs_name(), 'rs_name');
=======
        } 
        ok( $obj->rsname, 'rs name');
        diag $obj->rsname;
        #diag Dumper $obj;
>>>>>>> cf33a3273ba243b535bb013ba32a31dda7f6e2b1:t/core/Replicasets.t
};



done_testing();
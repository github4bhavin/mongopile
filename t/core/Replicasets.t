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

#___ METHODS EXIST TEST

my @methods = ('new',
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
        ok( $obj->rsname, 'rs name');
        ok( $obj->get_members , 'get members' );
        
        my @rs_members = $obj->get_members;
        print Dumper @rs_members;
        foreach my $member ( @rs_members ){
            print "\n member : $member ";
			#print Dumper ( $obj->get_member( $member )->mongodbBuild );
			#print Dumper ( $obj->get_member( $member )->cursor );			      
			print Dumper ( $obj->get_member( $member )->databases );
        }
        
        
};



done_testing();
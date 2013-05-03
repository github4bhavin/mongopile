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
};

use_ok('mongopile::Replicasets');

my $obj = new_ok('mongopile::Replicasets');
   $obj->host('dfprdzwkvdb1.df.jabodo.com');
   $obj->port('28017');

   

SKIP: {
        my $rs_status;
        if ( !($rs_status = $obj->get_status() ) ) {
           diag $obj->error;
           skip 'no local mongo instance running' , 1 ;
        } 
        use Data::Dumper;
        diag Dumper $obj->rs_data;
        diag $obj->host , " " , $obj->port , " " , $obj->rs_name; 
        diag Dumper $obj->get_stats_for_member( 'dfprdzwkvdb1.df.jabodo.com', '27017' );
        diag Dumper $obj->get_members();
};

 

done_testing();
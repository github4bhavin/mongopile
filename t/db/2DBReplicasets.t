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
   push @INC , join '/', @_PROJECT_DIR , 'DB';      
};

use_ok( 'mongopile::DB::Replicasets' );
my $obj = new_ok( 'mongopile::DB::Replicasets' );

diag Dumper $obj;

diag Dumper $obj->dbh;

can_ok( $obj->dbh , 'selectall_arrayref' );

done_testing();
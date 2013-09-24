#!/usr/bin/perl

use Test::More;
use Data::Dumper;
use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

my @_PROJECT_DIR;

BEGIN {
   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR; # Members
   pop @_PROJECT_DIR; # replicates
   pop @_PROJECT_DIR; # core
   pop @_PROJECT_DIR; # t

   push @INC , join '/', @_PROJECT_DIR , 'lib';
      
};

use_ok('mongopile::CORE::Replicasets::Member::Database');

my $obj = new mongopile::CORE::Replicasets::Member::Database();

done_testing;
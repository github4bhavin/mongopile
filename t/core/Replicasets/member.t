#!/usr/bin/perl

use Test::More;
use Data::Dumper;
use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

my @_PROJECT_DIR;

BEGIN {
   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR; # replicates
   pop @_PROJECT_DIR; # core
   pop @_PROJECT_DIR; # t

   push @INC , join '/', @_PROJECT_DIR , 'lib';
   push @INC , join '/', @_PROJECT_DIR , 'mongopile';
   push @INC , join '/', @_PROJECT_DIR , 'CORE';
   push @INC , join '/', @_PROJECT_DIR , 'Replicasets';
};

my $required_version = 1.0;

SKIP: {

 skip "Required Version ($required_version) not present" , 1 
 unless use_ok('mongopile::CORE::Replicasets::Member' , 
               $required_version );

 my $obj = new mongopile::CORE::Replicasets::Member();

 map{ can_ok( $obj, $_ ); } 
 (
 	'new',
 	'js',
 	'memberid',
 	'network',
 	'opcounters',
 	'asserts',
 	'uptime',
 	'optime',
 	'lastHeartbeat',
 	'pingms',
 	'isMaster',
 	'healthStatus',
 	'oidMachine',
 	'connections',
 	'indexCounters',
 	'replicasetState',
 	'backgroundFlushed',
 	'priority',
 	'arbiter',
 	'mongodbBuild',
 	'cursor',
 	'databases',
 	'globalLock',
 	'memory',
 );

};

done_testing;

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

my %mongopileRequiredModules = 
   (
       'mongopile'         => 1.0,
       'mongopile::config' => 1.0,
	   'DBI'               => 0,
	   'DBD::SQLite'       => 0,
	   'Mojolicious'       => 2.93,
	   'File::Basename'    => 0,
	   'File::Spec::Functions' => 0,
	   'mongopile::DB'     => 0,
	   'mongopile::CORE::Replicasets' => 0,
	   'mongopile::DB::Replicasets'   => 0,
	   'Storable'          => 0,
	   'Data::Dumper'      => 0,
	   'threads'           => 0,
   );
      use_ok( 'Mojolicious::Commands' );
 map { use_ok ( $_ , $mongopileRequiredModules { $_} ); } keys %mongopileRequiredModules;
 
 done_testing;
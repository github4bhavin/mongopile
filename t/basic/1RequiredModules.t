
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
       'mongopile' => 1.0,
       'mongopile::config' => 1.0
   );
   
 
 map { use_ok ( $_ , $mongopileRequiredModules { $_} ); } keys %mongopileRequiredModules;
 
 done_testing;
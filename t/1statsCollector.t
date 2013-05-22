
use Test::More;

use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };
use Data::Dumper;

my @_PROJECT_DIR;

BEGIN {
   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR;
   push @INC , join '/', @_PROJECT_DIR , 'lib';
};

use_ok( 'mongopile::StatsCollector' );

my $obj = new_ok( 'mongopile::StatsCollector');
ok( $obj->get_status_for_all_replicasets(), 'get status ');   
done_testing;
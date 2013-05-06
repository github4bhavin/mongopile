package mongopile::StatsCollector;
$VERSION = 1.0;

#--------------------------------------------------------------------#
# Project : mongopile                                                #
# Author  : Bhavin Patel                                             #
# Purpose : Collect stats for all replicasets                        #
#--------------------------------------------------------------------#

use File::Basename          qw { dirname          };
use File::Spec::Functions   qw { splitdir rel2abs };

use mongopile::DB;
use mongopile::CORE::Replicasets; 
use mongopile::DB::Replicasets;

my @BASEDIR;

BEGIN {
   @BASEDIR = ( splitdir ( rel2abs( dirname( __FILE__ ) ) ) );
   pop @BASEDIR;
   push @INC , join '/' , @BASEDIR , 'lib' ;
};
my $LOCKFILE = join '/' , @BASEDIR , 'etc' , 'mongopile.lock';
my $PIDFILE  = join '/' , @BASEDIR , 'etc' , 'mongopile.pid' ;

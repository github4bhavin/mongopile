package mongopile;
$VERSION = 1.0;

#--------------------------------------------------------------------#
# Project : mongopile                                                #
# Author  : Bhavin Patel                                             #
# Purpose : Main class which hooks up into mojo framework            #
#--------------------------------------------------------------------#

use Mojo::Base 'Mojolicious'
use File::Basename          qw { dirname          };
use File::Spec::Functions   qw { splitdir rel2abs };

my @BASEDIR = ( splitdir ( rel2abs( dirname( __FILE__ ) ) ) );
   pop @BASEDIR;
   push @INC , join '/' , @BASEDIR , 'lib' ;

my $LOCKFILE = join '/' , @BASEDIR , 'etc' , 'mongopile.lock';
my $PIDFILE  = join '/' , @BASEDIR , 'etc' , 'mongopile.pid' ;

#
# main Startup hook for mojo
#
sub startup {

}

1;
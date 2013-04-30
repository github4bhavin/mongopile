package mongopile;
$VERSION = 1.0;

#--------------------------------------------------------------------#
# Project : mongopile                                                #
# Author  : Bhavin Patel                                             #
# Purpose : Main class which hooks up into mojo framework            #
#--------------------------------------------------------------------#

use Mojo::Base 'Mojolicious';
use File::Basename          qw { dirname          };
use File::Spec::Functions   qw { splitdir rel2abs };

my @BASEDIR = ( splitdir ( rel2abs( dirname( __FILE__ ) ) ) );
   pop @BASEDIR;
   push @INC , join '/' , @BASEDIR , 'lib' ;

my $LOCKFILE = join '/' , @BASEDIR , 'etc' , 'mongopile.lock';
my $PIDFILE  = join '/' , @BASEDIR , 'etc' , 'mongopile.pid' ;
my $DBFILE   = 'mongopile.sqlite';

has schema => sub {
	my $dbname = 'mongopile';
	return DBI->connect( "dbi:SQLite:dbnmae=$DBFILE","","",
	                    { RaiseError => 1, PrintError => 1} );
};

#
# main Startup hook for mojo
#
sub startup {
  my $self = shift;
  my $ROUTES = $self->routes;

	#___ Public routes

  $self->app->secret ( 'M0ng0P1le' );
  $self->app->config ( hypnotoad => {
  							listen    => [ 'https://*:444'],
  							lock_file => $LOCKFILE,
  							pid_file  => $PIDFILE
                     });

  #___Register helpers
  $self->helper( db => sub { $self->app->schema } );

  my $REPLICASET_ROUTES = $ROUTES->any('replicasets')->to( controller=> 'Replicasets' , action => 'access');
     $REPLICASET_ROUTES->get('getall')->to(controller => 'Replicasets' , action => 'get_all' ); 
     $REPLICASET_ROUTES->post('/add')->to(controller => 'Replicasets' , action => 'add' );        

}

1;
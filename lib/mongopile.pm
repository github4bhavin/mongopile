package mongopile;
$VERSION = 1.0;

#--------------------------------------------------------------------#
# Project : mongopile                                                #
# Author  : Bhavin Patel                                             #
# Purpose : Main class which hooks up into mojo framework            #
#--------------------------------------------------------------------#

use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::RenderFile;

use DBI;
use File::Basename          qw { dirname          };
use File::Spec::Functions   qw { splitdir rel2abs };

use mongopile::CORE::Replicasets; 
use mongopile::DB;
use mongopile::DB::Replicasets;

my @BASEDIR = ( splitdir ( rel2abs( dirname( __FILE__ ) ) ) );
   pop @BASEDIR;
   push @INC , join '/' , @BASEDIR , 'lib' ;

my $LOCKFILE = join '/' , @BASEDIR , 'etc' , 'mongopile.lock';
my $PIDFILE  = join '/' , @BASEDIR , 'etc' , 'mongopile.pid' ;


has core_replicasets => sub {
    return new mongopile::CORE::Replicasets();
};

has db_replicasets => sub {
    return new mongopile::DB::Replicasets();
};

#
# main Startup hook for mojo
#
sub startup {
  my $self = shift;
  my $ROUTES = $self->routes;

	

  $self->app->secret ( 'M0ng0P1le' );
  $self->app->config ( hypnotoad => {
  							listen    => [ 'https://*:444'],
  							lock_file => $LOCKFILE,
  							pid_file  => $PIDFILE
                     });

  #___ Plugins
  $self->plugin('RenderFile');

  #___Register helpers
  #  $self->helper( db         => sub { $self->app->schema } );

  $self->helper( core_replicasets => sub { $self->app->core_replicaset } );
  $self->helper( db_replicasets   => sub { $self->app->db_replicasets   } );
  
  #___ Public routes
     $ROUTES->get('/')->to( controller => 'Dashboard' , action => 'show' );
     $ROUTES->get('/dashboard')->to( controller => 'Dashboard' , action => 'show' );

     
  my $REPLICASET_ROUTES = $ROUTES->bridge('replicasets')
                       ->to( controller => 'GUI::Replicasets' , action => 'access'  );
     $REPLICASET_ROUTES->get('getall')
                       ->to( controller => 'GUI::Replicasets' , action => 'get_all' ); 
     $REPLICASET_ROUTES->post('/add')
                       ->to( controller => 'GUI::Replicasets' , action => 'add'     );        

}

1;
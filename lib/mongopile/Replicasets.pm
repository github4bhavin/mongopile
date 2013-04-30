package mongopile::Replicasets;

$VERSION = 1.0;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub access {
	return 1;
}

sub get_all {

}

sub get_replicasets {

}

sub add_replicaset {
  my $self = shift;
  my $model = $self->param('model') ;
  $self->app->log->debug ( Dumper $model );
  
  $self->render(json => { id => 1 } );
}
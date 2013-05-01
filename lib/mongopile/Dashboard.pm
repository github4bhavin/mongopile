package mongopile::Dashboard;

$VERSION = 1.0;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub show {
   my $self = shift;
      $self->session('active' => 1 );
   return 1;
}

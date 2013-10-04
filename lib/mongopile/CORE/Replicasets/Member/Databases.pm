package mongopile::CORE::Replicasets::Member::Databases;

use mongopile::CORE::Replicasets::Member::Database;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'totalSize'} = undef unless defined $self->{'totalSize'};
  return $self;
}

sub totalSize { $_[0]->{'totalSize' } = $_[1] if defined ($_[1]); return $_[0]->{'totalSize' };  }
sub add_databases {
  my $self = shift;
  my $_database_obj = shift;
  if( defined ($_database_obj) &&
      ref $_database_obj eq 'mongopile::CORE::Replicasets::Member::Database' ){
  		push @{ $self->{'databases'} } , $_database_obj;
  } 
  return 1;
}

sub databases {
  my $self = shift;
  return $self->{'databases'};
}

1;
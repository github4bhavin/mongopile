package mongopile::CORE::Replicasets::Member::Databases;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'totalSize'} = undef unless defined $self->{'totalSize'};
  if ( ref $self->{'databases'} ne 'mongopile::CORE::Replicasets::Member::Database')
  {
     $self->{'databases'} = new mongopile::CORE::Replicasets::Member::Database();
  }
  return $self;
}

1;
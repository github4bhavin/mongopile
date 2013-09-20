package mongopile::CORE::Replicasets::Member::Connections;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'current'  } = undef unless defined $self->{'current'  };
  $self->{'available'} = undef unless defined $self->{'available'};
  return $self;
}

1;

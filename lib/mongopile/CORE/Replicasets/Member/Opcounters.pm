package mongopile::CORE::Replicasets::Member::Opcounters;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'insert' } = undef unless defined $self->{'insert' };
  $self->{'query'  } = undef unless defined $self->{'query'  };
  $self->{'update' } = undef unless defined $self->{'update' };
  $self->{'delete' } = undef unless defined $self->{'delete' };
  $self->{'getmore'} = undef unless defined $self->{'getmore'};
  $self->{'command'} = undef unless defined $self->{'command'};
  return $self;
}

1;
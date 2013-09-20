package mongopile::CORE::Replicasets::Member::IndexCounters;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'accesses' } = undef unless defined $self->{'accesses' };
  $self->{'hits'     } = undef unless defined $self->{'hits'     };
  $self->{'misses'   } = undef unless defined $self->{'misses'   };
  $self->{'missRatio'} = undef unless defined $self->{'missRatio'};
  return $self;
}

1;

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

sub accesses  { $_[0]->{'accesses' } = $_[1] if defined ($_[1]); return $_[0]->{'accesses' };  }
sub hits      { $_[0]->{'hits'     } = $_[1] if defined ($_[1]); return $_[0]->{'hits'     };  }
sub misses    { $_[0]->{'misses'   } = $_[1] if defined ($_[1]); return $_[0]->{'misses'   };  }
sub missRatio { $_[0]->{'missRatio'} = $_[1] if defined ($_[1]); return $_[0]->{'missRatio'};  }

1;

package mongopile::CORE::Replicasets::Member::Asserts;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'regular' } = undef unless defined $self->{'regular' };
  $self->{'warnings'} = undef unless defined $self->{'warnings'};
  $self->{'msg'     } = undef unless defined $self->{'msg'     };
  $self->{'user'    } = undef unless defined $self->{'user'    };
  $self->{'rollover'} = undef unless defined $self->{'rollover'};
  return $self;
}

1;
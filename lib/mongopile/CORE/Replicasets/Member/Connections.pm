package mongopile::CORE::Replicasets::Member::Connections;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'current'  } = undef unless defined $self->{'current'  };
  $self->{'available'} = undef unless defined $self->{'available'};
  return $self;
}

sub current   { $_[0]->{'current'   } = $_[1] if defined ($_[1]); return $_[0]->{'current'   };  }
sub available { $_[0]->{'available' } = $_[1] if defined ($_[1]); return $_[0]->{'available' };  }

1;

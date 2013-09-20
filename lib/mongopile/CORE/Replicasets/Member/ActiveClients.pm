package mongopile::CORE::Replicasets::Member::ActiveClients;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'total'  } = undef unless defined $self->{'totla'  };
  $self->{'readers'} = undef unless defined $self->{'readers'};
  $self->{'writers'} = undef unless defined $self->{'writers'};
  return $self;
}

sub total   { $_[0]->{'total'   } = $_[1] if defined ($_[1]); return $_[0]->{'total'   };  }
sub readers { $_[0]->{'readers' } = $_[1] if defined ($_[1]); return $_[0]->{'readers' };  }
sub writers { $_[0]->{'writers' } = $_[1] if defined ($_[1]); return $_[0]->{'writers' };  }

1;
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

sub insert  { $_[0]->{'insert' } = $_[1] if defined ($_[1]); return $_[0]->{'insert' };  }
sub query   { $_[0]->{'query'  } = $_[1] if defined ($_[1]); return $_[0]->{'query'  };  }
sub update  { $_[0]->{'update' } = $_[1] if defined ($_[1]); return $_[0]->{'update' };  }
sub delete  { $_[0]->{'delete' } = $_[1] if defined ($_[1]); return $_[0]->{'delete' };  }
sub getmore { $_[0]->{'getmore'} = $_[1] if defined ($_[1]); return $_[0]->{'getmore'};  }
sub command { $_[0]->{'command'} = $_[1] if defined ($_[1]); return $_[0]->{'command'};  }

1;
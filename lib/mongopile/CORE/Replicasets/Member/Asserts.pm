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

sub regular  { $_[0]->{'regular'  } = $_[1] if defined ($_[1]); return $_[0]->{'regular'  };  }
sub warnings_ { $_[0]->{'warnings' } = $_[1] if defined ($_[1]); return $_[0]->{'warnings' };  }
sub msg      { $_[0]->{'msg'      } = $_[1] if defined ($_[1]); return $_[0]->{'msg'      };  }
sub user     { $_[0]->{'user'     } = $_[1] if defined ($_[1]); return $_[0]->{'user'     };  }
sub rollover { $_[0]->{'rollover' } = $_[1] if defined ($_[1]); return $_[0]->{'rollover' };  }

1;
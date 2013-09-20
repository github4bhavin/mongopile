package mongopile::CORE::Replicasets::Member::BackgroundFlushes;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'flushes'      } = undef unless defined $self->{'flushes'      };
  $self->{'total_ms'     } = undef unless defined $self->{'total_ms'     };
  $self->{'average_ms'   } = undef unless defined $self->{'average_ms'   };
  $self->{'last_ms'      } = undef unless defined $self->{'last_ms'      };
  $self->{'last_finished'} = undef unless defined $self->{'last_finished'};
  return $self;
}

sub flushes       { $_[0]->{'flushed'       } = $_[1] if defined ($_[1]); return $_[0]->{'flushed'       };  }
sub total_ms      { $_[0]->{'total_ms'      } = $_[1] if defined ($_[1]); return $_[0]->{'total_ms'      };  }
sub average_ms    { $_[0]->{'average_ms'    } = $_[1] if defined ($_[1]); return $_[0]->{'average_ms'    };  }
sub last_ms       { $_[0]->{'last_ms'       } = $_[1] if defined ($_[1]); return $_[0]->{'last_ms'       };  }
sub last_finished { $_[0]->{'last_finished' } = $_[1] if defined ($_[1]); return $_[0]->{'last_finished' };  }

1;
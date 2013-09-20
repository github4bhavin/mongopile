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

1;
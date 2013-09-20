package mongopile::CORE::Replicasets::Member::Network;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'bytesIn'    } = undef unless defined $self->{'bytesIn'    };
  $self->{'bytesOut'   } = undef unless defined $self->{'bytesOut'   };
  $self->{'numRequests'} = undef unless defined $self->{'numRequests'};
  return $self;
}

1;
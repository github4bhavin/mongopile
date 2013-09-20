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

sub byteIn      { $_[0]->{'byteIn'      } = $_[1] if defined ($_[1]); return $_[0]->{'byteIn'      };  }
sub byteOut     { $_[0]->{'byteOut'     } = $_[1] if defined ($_[1]); return $_[0]->{'byteOut'     };  }
sub numRequests { $_[0]->{'numRequests' } = $_[1] if defined ($_[1]); return $_[0]->{'numRequests' };  }

1;
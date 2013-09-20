package mongopile::CORE::Replicasets::Member::Database;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'name'      } = undef unless defined $self->{'name'      };
  $self->{'sizeOnDisk'} = undef unless defined $self->{'sizeOnDisk'};
  $self->{'empty'     } = undef unless defined $self->{'empty'     };
  return $self;
}

sub name       { $_[0]->{'name'       } = $_[1] if defined ($_[1]); return $_[0]->{'name'       };  }
sub sizeOnDisk { $_[0]->{'sizeOnDisk' } = $_[1] if defined ($_[1]); return $_[0]->{'sizeOnDisk' };  }
sub empty      { $_[0]->{'empty'      } = $_[1] if defined ($_[1]); return $_[0]->{'empty'      };  }

1;
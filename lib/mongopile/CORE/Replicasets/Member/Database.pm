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

1;
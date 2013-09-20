package mongopile::CORE::Replicasets::Member::CurrentQueue;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'total'  } = undef unless defined $self->{'totla'  };
  $self->{'readers'} = undef unless defined $self->{'readers'};
  $self->{'writers'} = undef unless defined $self->{'writers'};
  return $self;
}

1;

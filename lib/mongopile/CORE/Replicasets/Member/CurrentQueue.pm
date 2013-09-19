package mongopile::CORE::Replicasets::Member::CurrentQueue;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;

  return $self;
}

1;
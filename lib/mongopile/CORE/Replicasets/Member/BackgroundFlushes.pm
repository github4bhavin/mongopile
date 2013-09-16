package mongopile::CORE::Replicasets::Member::BackgroundFlushes;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  return $self;
}

1;
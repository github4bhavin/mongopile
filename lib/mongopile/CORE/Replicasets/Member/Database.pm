package mongopile::CORE::Replicasets::Member::Database;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  return $self;
}

1;
package mongopile::CORE::Replicasets::Member::Cursor;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  return $self;
}

1;
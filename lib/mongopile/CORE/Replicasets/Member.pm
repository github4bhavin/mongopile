package mongopile::CORE::Replicasets::Member;

$VERSION = 1.0;

sub new {
 my $class = shift;
 my $self = {@_};
 bless $self, $class;
 return $self;

}
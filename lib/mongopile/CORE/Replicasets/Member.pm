package mongopile::CORE::Replicasets::Member;

$VERSION = 1.0;

sub new {
 my $class = shift;
 my $self = {@_};
 bless $self, $class;

  #Replicasets Members should have following properties
  
  $self->{ 'memberid' };
  $self->{ 'name'     }; #hostname
  $self->{ 'healthStatus' };
  $self->{ 'replicasetState'}; # same as stateStr and state
  $self->{ 'uptime' }; # server uptime
  $self->{ 'optime' }; # oplog uptime
  $self->{ 'lastHeartbeat' };
  $self->{'pingms' };
  
  # MongoDB build info
  
  $self->{ 'mongodbBuild' }->{'}
 
 
 return $self;

}

sub 
package mongopile::CORE::Replicasets::Member::MongodbBuild;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  $self->{ 'version'           }; # mongo version
  $self->{ 'gitVersion'        }; # mongo git repo version
  $self->{ 'sysInfo'           }; # uname -a
  $self->{ 'bits'              }; # 32 or 64 bit machine
  $self->{ 'debug'             }; # debug on or off
  $self->{ 'maxBsonObjectSize' }; # max bson size allowed
  $self->{ 'mongoProcessname'  }; # mongo process name
  $self->{ 'writeBacksQueued'  }; # write back queue allowed? 
  
  return $self;
}

1;
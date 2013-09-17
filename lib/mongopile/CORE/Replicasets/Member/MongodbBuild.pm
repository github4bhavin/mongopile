package mongopile::CORE::Replicasets::Member::MongodbBuild;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  $self->{ 'version'           } = undef unless $self->{'version'          } ; # mongo version
  $self->{ 'gitVersion'        } = undef unless $self->{'gitVersion'       }; # mongo git repo version
  $self->{ 'sysInfo'           } = undef unless $self->{'sysInfo'          }; # uname -a
  $self->{ 'bits'              } = undef unless $self->{'bits'             }; # 32 or 64 bit machine
  $self->{ 'debug'             } = undef unless $self->{'debug'            }; # debug on or off
  $self->{ 'maxBsonObjectSize' } = undef unless $self->{'maxBsonObjectSize'}; # max bson size allowed
  $self->{ 'mongoProcessname'  } = 'mongod' unless $self->{'mongoProcessname' }; # mongo process name
  $self->{ 'writeBacksQueued'  } = 'false' unless $self->{ 'writeBackQueued' }; # write back queue allowed? 
  
  return $self;
}

1;
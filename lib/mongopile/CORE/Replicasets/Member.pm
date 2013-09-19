package mongopile::CORE::Replicasets::Member;

$VERSION = 1.0;

use mongopile::CORE::Replicasets::Member::MongodbBuild;
use mongopile::CORE::Replicasets::Member::Cursor;
use mongopile::CORE::Replicasets::Member::Databases;
use mongopile::CORE::Replicasets::Member::GlobalLock;
use mongopile::CORE::Replicasets::Member::Memory;
use mongopile::CORE::Replicasets::Member::Connections;
use mongopile::CORE::Replicasets::Member::IndexCounters;
use mongopile::CORE::Replicasets::Member::BackgroundFlushes;
use mongopile::CORE::Replicasets::Member::Network;
use mongopile::CORE::Replicasets::Member::Opcounters;
use mongopile::CORE::Replicasets::Member::Asserts;

sub new {
 my $class = shift;
 my $self = {@_};
 bless $self, $class;

  #Replicasets Members should have following properties
  
  $self->{ 'memberid'        };
  $self->{ 'name'            }; #hostname
  $self->{ 'healthStatus'    };
  $self->{ 'replicasetState' }; # same as stateStr and state
  $self->{ 'uptime'          }; # server uptime
  $self->{ 'optime'          }; # oplog uptime
  $self->{ 'lastHeartbeat'   };
  $self->{'pingms'           };
  $self->{'isMaster'         };
  $self->{'js'               };
  $self->{'oidMachine'       };
  $self->{'localTime'        };


  if ( !defiend (
           $self->{ 'mongodbBuild'      })  && 
       ref $self->{ 'mongodbBuild'      }    eq 'mongopile::CORE::Replicasets::Member::mongodbBuild'        ) 	
       {   $self->{ 'mongodbBuild'      } =  new mongopile::CORE::Replicasets::Member::MongodbBuild();      }

  if ( !defiend (
           $self->{ 'cursor'            })  && 
       ref $self->{ 'cursor'            }   eq 'mongopile::CORE::Replicasets::Member::Cursor'               )
       {   $self->{ 'cursor'            } = new mongopile::CORE::Replicasets::Member::Cursor();             }

  if ( !defiend (
           $self->{ 'databases'         })  && 
       ref $self->{ 'databases'         }   eq 'mongopile::CORE::Replicasets::Member::Databases'            ) 	
      {    $self->{ 'databases'         } = new mongopile::CORE::Replicasets::Member::Databases();          }

  if ( !defiend (
           $self->{ 'globalLock'        })  && 
       ref $self->{ 'globalLock'        }   eq 'mongopile::CORE::Replicasets::Member::GlobalLock'           ) 	
      {    $self->{ 'globalLock'        } = new mongopile::CORE::Replicasets::Member::GlobalLock();         }

  if ( !defiend (
           $self->{ 'memory'            })  && 
       ref $self->{ 'memeory'           }   eq 'mongopile::CORE::Replicasets::Member::Memory'               ) 	
      {    $self->{ 'memeory'           } = new mongopile::CORE::Replicasets::Member::Memory();             }

  if ( !defiend (
           $self->{ 'connections'       })  && 
       ref $self->{ 'connections'       }   eq 'mongopile::CORE::Replicasets::Member::Connections'          ) 	
      {    $self->{ 'connections'       } = new mongopile::CORE::Replicasets::Member::Connections();        }

  if ( !defiend (
           $self->{ 'indexCounters'     })  && 
       ref $self->{ 'indexCounters'     }   eq 'mongopile::CORE::Replicasets::Member::IndexCounters'        ) 	
      {    $self->{ 'indexCounters'     } = new mongopile::CORE::Replicasets::Member::IndexCounters();      }

  if ( !defiend (
           $self->{ 'backgroundFlushed' })  && 
       ref $self->{ 'backgroundFlushed' }   eq 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   ) 	
      {    $self->{ 'backgroundFlushed' } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); }
 
  if ( !defiend (
           $self->{ 'network'           })  && 
       ref $self->{ 'network'           }   eq 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   ) 	
      {    $self->{ 'network'           } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); } 

  if ( !defiend (
           $self->{ 'opcounters'        })  && 
       ref $self->{ 'opcounters'        }   eq 'mongopile::CORE::Replicasets::Member::Opcounters'          ) 	
      {    $self->{ 'opcounters'        } = new mongopile::CORE::Replicasets::Member::Opcounters();        } 

  if ( !defiend (
           $self->{ 'asserts'           })  && 
       ref $self->{ 'asserts'           }   eq 'mongopile::CORE::Replicasets::Member::Asserts'             ) 	
      {    $self->{ 'asserts'           } = new mongopile::CORE::Replicasets::Member::Asserts();           }
 
 return $self;

}

1;
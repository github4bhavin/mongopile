package mongopile::CORE::Replicasets::Member;

$VERSION = 1.0;
my @PROJECT_DIR;
BEGIN {
use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

   @PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @PROJECT_DIR;
   pop @PROJECT_DIR;
   pop @PROJECT_DIR;
   push @INC, join '/' , @PROJECT_DIR;
};

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

  $self->{ 'memberid'        } = undef unless $self->{'memberid'       };
  $self->{ 'name'            } = undef unless $self->{'name'           }; #hostname
  $self->{ 'healthStatus'    } = undef unless $self->{'healthStatus'   };
  $self->{ 'replicasetState' } = undef unless $self->{'replicasetState'}; # same as stateStr and state
  $self->{ 'uptime'          } = undef unless $self->{'uptime'         }; # server uptime
  $self->{ 'optime'          } = undef unless $self->{'optime'         }; # oplog uptime
  $self->{ 'lastHeartbeat'   } = undef unless $self->{'lastHeartbeat'  };
  $self->{'pingms'           } = undef unless $self->{'pingms'         };
  $self->{'isMaster'         } = undef unless $self->{'isMaster'       };
  $self->{'js'               } = undef unless $self->{'js'             };
  $self->{'oidMachine'       } = undef unless $self->{'oidMachine'     };
  $self->{'localTime'        } = undef unless $self->{'localTime'      };


  if ( !defined (
           $self->{ 'mongodbBuild'      })  &&
       ref $self->{ 'mongodbBuild'      }    eq 'mongopile::CORE::Replicasets::Member::mongodbBuild'        )
       {   $self->{ 'mongodbBuild'      } =  new mongopile::CORE::Replicasets::Member::MongodbBuild();      }

  if ( !defined (
           $self->{ 'cursor'            })  &&
       ref $self->{ 'cursor'            }   eq 'mongopile::CORE::Replicasets::Member::Cursor'               )
       {   $self->{ 'cursor'            } = new mongopile::CORE::Replicasets::Member::Cursor();             }

  if ( !defined (
           $self->{ 'databases'         })  &&
       ref $self->{ 'databases'         }   eq 'mongopile::CORE::Replicasets::Member::Databases'            )
      {    $self->{ 'databases'         } = new mongopile::CORE::Replicasets::Member::Databases();          }

  if ( !defined (
           $self->{ 'globalLock'        })  &&
       ref $self->{ 'globalLock'        }   eq 'mongopile::CORE::Replicasets::Member::GlobalLock'           )
      {    $self->{ 'globalLock'        } = new mongopile::CORE::Replicasets::Member::GlobalLock();         }

  if ( !defined (
           $self->{ 'memory'            })  &&
       ref $self->{ 'memeory'           }   eq 'mongopile::CORE::Replicasets::Member::Memory'               )
      {    $self->{ 'memeory'           } = new mongopile::CORE::Replicasets::Member::Memory();             }

  if ( !defined (
           $self->{ 'connections'       })  &&
       ref $self->{ 'connections'       }   eq 'mongopile::CORE::Replicasets::Member::Connections'          )
      {    $self->{ 'connections'       } = new mongopile::CORE::Replicasets::Member::Connections();        }

  if ( !defined (
           $self->{ 'indexCounters'     })  &&
       ref $self->{ 'indexCounters'     }   eq 'mongopile::CORE::Replicasets::Member::IndexCounters'        )
      {    $self->{ 'indexCounters'     } = new mongopile::CORE::Replicasets::Member::IndexCounters();      }

  if ( !defined (
           $self->{ 'backgroundFlushed' })  &&
       ref $self->{ 'backgroundFlushed' }   eq 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   )
      {    $self->{ 'backgroundFlushed' } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); }

  if ( !defined (
           $self->{ 'network'           })  &&
       ref $self->{ 'network'           }   eq 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   )
      {    $self->{ 'network'           } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); }

  if ( !defined (
           $self->{ 'opcounters'        })  &&
       ref $self->{ 'opcounters'        }   eq 'mongopile::CORE::Replicasets::Member::Opcounters'          )
      {    $self->{ 'opcounters'        } = new mongopile::CORE::Replicasets::Member::Opcounters();        }

  if ( !defined (
           $self->{ 'asserts'           })  &&
       ref $self->{ 'asserts'           }   eq 'mongopile::CORE::Replicasets::Member::Asserts'             )
      {    $self->{ 'asserts'           } = new mongopile::CORE::Replicasets::Member::Asserts();           }

 return $self;

}


1;
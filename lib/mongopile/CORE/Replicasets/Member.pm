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

<<<<<<< HEAD
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

=======
  #Replicasets Members should have following properties

  $self->{ 'memberid'        } = undef;
  $self->{ 'name'            } = 'localhost'; #hostname
  $self->{ 'healthStatus'    } = undef;
  $self->{ 'replicasetState' } = undef; # same as stateStr and state
  $self->{ 'uptime'          } = undef; # server uptime
  $self->{ 'optime'          } = undef; # oplog uptime
  $self->{ 'lastHeartbeat'   } = undef;
  $self->{ 'pingms'          } = undef;
  $self->{ 'isMaster'        } = undef;
  $self->{ 'js'              } = undef;
  $self->{ 'oidMachine'      } = undef;
  $self->{ 'localTime'       } = undef;
  $self->{ 'priority'        } = undef;
>>>>>>> cf33a3273ba243b535bb013ba32a31dda7f6e2b1

  if ( !defined (
           $self->{ 'mongodbBuild'      })  &&
       ref $self->{ 'mongodbBuild'      }    ne 'mongopile::CORE::Replicasets::Member::mongodbBuild'        )
       {   $self->{ 'mongodbBuild'      } =  new mongopile::CORE::Replicasets::Member::MongodbBuild();      }

  if ( !defined (
           $self->{ 'cursor'            })  &&
       ref $self->{ 'cursor'            }   ne 'mongopile::CORE::Replicasets::Member::Cursor'               )
       {   $self->{ 'cursor'            } = new mongopile::CORE::Replicasets::Member::Cursor();             }

  if ( !defined (
           $self->{ 'databases'         })  &&
       ref $self->{ 'databases'         }   ne 'mongopile::CORE::Replicasets::Member::Databases'            )
      {    $self->{ 'databases'         } = new mongopile::CORE::Replicasets::Member::Databases();          }

  if ( !defined (
           $self->{ 'globalLock'        })  &&
       ref $self->{ 'globalLock'        }   ne 'mongopile::CORE::Replicasets::Member::GlobalLock'           )
      {    $self->{ 'globalLock'        } = new mongopile::CORE::Replicasets::Member::GlobalLock();         }

  if ( !defined (
           $self->{ 'memory'            })  &&
       ref $self->{ 'memeory'           }   ne 'mongopile::CORE::Replicasets::Member::Memory'               )
      {    $self->{ 'memeory'           } = new mongopile::CORE::Replicasets::Member::Memory();             }

  if ( !defined (
           $self->{ 'connections'       })  &&
       ref $self->{ 'connections'       }   ne 'mongopile::CORE::Replicasets::Member::Connections'          )
      {    $self->{ 'connections'       } = new mongopile::CORE::Replicasets::Member::Connections();        }

  if ( !defined (
           $self->{ 'indexCounters'     })  &&
       ref $self->{ 'indexCounters'     }   ne 'mongopile::CORE::Replicasets::Member::IndexCounters'        )
      {    $self->{ 'indexCounters'     } = new mongopile::CORE::Replicasets::Member::IndexCounters();      }

  if ( !defined (
           $self->{ 'backgroundFlushed' })  &&
       ref $self->{ 'backgroundFlushed' }   ne 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   )
      {    $self->{ 'backgroundFlushed' } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); }

  if ( !defined (
           $self->{ 'network'           })  &&
       ref $self->{ 'network'           }   ne 'mongopile::CORE::Replicasets::Member::BackgroundFlushes'   )
      {    $self->{ 'network'           } = new mongopile::CORE::Replicasets::Member::BackgroundFlushes(); }

  if ( !defined (
           $self->{ 'opcounters'        })  &&
       ref $self->{ 'opcounters'        }   ne 'mongopile::CORE::Replicasets::Member::Opcounters'          )
      {    $self->{ 'opcounters'        } = new mongopile::CORE::Replicasets::Member::Opcounters();        }

  if ( !defined (
           $self->{ 'asserts'           })  &&
       ref $self->{ 'asserts'           }   ne 'mongopile::CORE::Replicasets::Member::Asserts'             )
      {    $self->{ 'asserts'           } = new mongopile::CORE::Replicasets::Member::Asserts();           }

 return $self;

}

sub js                { $_[0]->{'js'               } = $_[1] if defined($_[1]); $_[0]->{'js'               }; }
sub memory            { $_[0]->{'memory'           } = $_[1] if defined($_[1]); $_[0]->{'memory'           }; }
sub memberid          { $_[0]->{'memberid'         } = $_[1] if defined($_[1]); $_[0]->{'memberid'         }; }
sub name              { $_[0]->{'name'             } = $_[1] if defined($_[1]); $_[0]->{'name'             }; }
sub network           { $_[0]->{'network'          } = $_[1] if defined($_[1]); $_[0]->{'network'          }; }
sub opcounters        { $_[0]->{'opcounters'       } = $_[1] if defined($_[1]); $_[0]->{'opcounters'       }; }
sub asserts           { $_[0]->{'asserts'          } = $_[1] if defined($_[1]); $_[0]->{'asserts'          }; }
sub uptime            { $_[0]->{'uptime'           } = $_[1] if defined($_[1]); $_[0]->{'uptime'           }; }
sub optime            { $_[0]->{'optime'           } = $_[1] if defined($_[1]); $_[0]->{'optime'           }; }
sub lastHeartbeat     { $_[0]->{'lastHeartbeat'    } = $_[1] if defined($_[1]); $_[0]->{'lastHeartbeat'    }; }
sub pingms            { $_[0]->{'pingms'           } = $_[1] if defined($_[1]); $_[0]->{'pingms'           }; }
sub isMaster          { $_[0]->{'isMaster'         } = $_[1] if defined($_[1]); $_[0]->{'isMaster'         }; }
sub healthStatus      { $_[0]->{'healthStatus'     } = $_[1] if defined($_[1]); $_[0]->{'healthStatus'     }; }
sub oidMachine        { $_[0]->{'oidMachine'       } = $_[1] if defined($_[1]); $_[0]->{'oidMachine'       }; }
sub localTime         { $_[0]->{'localTime'        } = $_[1] if defined($_[1]); $_[0]->{'localTime'        }; }
sub mongodbBuild      { $_[0]->{'mongodbBuild'     } = $_[1] if defined($_[1]); $_[0]->{'mongodbBuild'     }; }
sub cursor            { $_[0]->{'cursor'           } = $_[1] if defined($_[1]); $_[0]->{'cursor'           }; }
sub databases         { $_[0]->{'databases'        } = $_[1] if defined($_[1]); $_[0]->{'databases'        }; }
sub globallock        { $_[0]->{'globallock'       } = $_[1] if defined($_[1]); $_[0]->{'globallock'       }; }
sub connections       { $_[0]->{'connections'      } = $_[1] if defined($_[1]); $_[0]->{'connections'      }; }
sub indexCounters     { $_[0]->{'indexCounters'    } = $_[1] if defined($_[1]); $_[0]->{'indexCounters'    }; }
sub replicasetState   { $_[0]->{'replicasetState'  } = $_[1] if defined($_[1]); $_[0]->{'replicasetState'  }; }
sub backgroundFlushed { $_[0]->{'backgroundFlushed'} = $_[1] if defined($_[1]); $_[0]->{'backgroundFlushed'}; }
sub priority          { $_[0]->{'priority'         } = $_[1] if defined($_[1]); $_[0]->{'priority'         }; }

sub mongodbBuild {
  $_[0]->{'mongodbBuild'} = $_[1] unless ref $_[1] eq 'mongopile::CORE::Replicasets::Member::MongodbBuild'; 
  return $_[0]->{'mongodbBuild'};
}

1;
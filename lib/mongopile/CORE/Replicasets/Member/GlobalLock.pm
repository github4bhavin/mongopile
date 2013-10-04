package mongopile::CORE::Replicasets::Member::GlobalLock;

use mongopile::CORE::Replicasets::Member::CurrentQueue;
use mongopile::CORE::Replicasets::Member::ActiveClients;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'totalTime'    } = undef unless defined $slef->{'totalTime'    };
  $self->{'lockTime'     } = undef unless defined $self->{'lockTime'     };
  $self->{'ratio'        } = undef unless defined $self->{'ratio'        };
  $self->{'currentQueue' } = new mongopile::CORE::Replicasets::Member::CurrentQueue();
  $self->{'activeClients'} = new mongopile::CORE::Replicasets::Member::ActiveClients();
    
  return $self;
}

sub totalTime { $_[0]->{'totalTime' } = $_[1] if defined ($_[1]); return $_[0]->{'totalTime'};  }
sub lockTime  { $_[0]->{'lockTime'  } = $_[1] if defined ($_[1]); return $_[0]->{'lockTime' };  }
sub ratio     { $_[0]->{'ratio'     } = $_[1] if defined ($_[1]); return $_[0]->{'ratio'    };  }
              
sub currentQueue {
  my $self = shift;
  my $_current_queue_obj = shift;
  if( defined ($_current_queue_obj) &&
      ref $_current_queue_obj eq 'mongopile::CORE::Replicasets::Member::CurrentQueue' ){
  		$self->{'currentQueue'} = $_current_queue_obj;
  } 
  return $self->{'currentQueue'};
}

sub activeClients {
  my $self = shift;
  my $_active_clients_obj = shift;
  if( defined ($_active_clients_obj) &&
      ref $_active_clients_obj eq 'mongopile::CORE::Replicasets::Member::ActiveClients' ){
  		$self->{'activeClients'} = $_active_clients_obj;
  } 
  return $self->{'activeClients'};
}

1;
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

  if(ref $self->{'currentQueue'} ne 'mongopile::CORE::Replicasets::Member::CurrentQueue')
  {
  	$self->{'currentQueue' } = new mongopile::CORE::Replicasets::Member::CurrentQueue();
  }
  if(ref $self->{'activeClients'} ne 'mongopile::CORE::Replicasets::Member::ActiveClients')
  {
  	$self->{'activeClients'} = new mongopile::CORE::Replicasets::Member::ActiveClients();
   }
  return $self;
}

1;
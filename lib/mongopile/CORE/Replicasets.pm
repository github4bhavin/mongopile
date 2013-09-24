package mongopile::CORE::Replicasets;

$VERSION = 1.0;

use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
   
      $self->{ 'error'   } = undef  if !$self->{'error'  };
      $self->{ 'members' } = ()     if !$self->{'members'};
      $self->{ 'rsname'  } = undef  if !$self->{'rsname' };
      
   return $self;
}

sub get_replicaset_status_using_rest {
   my $self = shift;
   my ($host,$port) = (@_);
   my $replicaset_data = $self->_replSetGetStatus();
      $self->rsname( $replicaset_data->{'set'} );

        foreach my $member ( @{ $replicaset_data->{'members'} } ){
            my $rs_member = new mongopile::CORE::Replicasets::Member();
               $rs_member->memberid( $member->{'_id'});
               $rs_member->name( $member->{'name'});
               $rs_member->healthStatus( $member->{'health'});
               $rs_member->replicasetState( $member->{'stateStr'});
               $rs_member->optime( $member->{'optime'}->{'t'});
               $rs_member->pingms( $member->{'pingMs'} );
               $rs_member->lastHeartbeat( $member->{'lastHeartbeat'}->{'$date'});
               $self->add_member( $rs_member );
               undef $rs_member;
        }
   
}

sub rsname     { $_[0]->{'rsname' } = $_[1] if defined ($_[1]); $_[0]->{'rsname'}; }
sub members    { $_[0]->{'rsname'}; }
sub add_member {
	return unless defined($_[1]);
	return unless ref $_[1] ne 'mongopile::CORE::Replicasets::Member'; 
	push @{ $_[0]->members } , $_[1];
}

sub _replSetGetStatus {
  my $self = shift;
  my ($host, $port, $https_flag ) = (@_);
  my $protocol = ( defined($https_flag ) ? 'https' : 'http';
  my $_UA = new Mojo::UserAgent();              
   
  my $_json_data = $_UA->get( join '', 
   	( $protocol , '://' , $host, $port, '/replSetGetStatus' , '?json=1')
      )->res->body;
  my $_data = undef;   

   eval { $_data = Mojo::JSON->decode ( $_json_data ); };
   
   return $_data;
   
}

sub error {
   my $self = shift;
   my @new_val = @_;
   if ( @new_val ){
       $self->{ 'error' } = $self->{ 'error' } . join ' ', @new_val;
   } else { 
       my $retval = $self->{'error'};
          $self->{ 'error' } = '';
       return $retval ;
   }
}

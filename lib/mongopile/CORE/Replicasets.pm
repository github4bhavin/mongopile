package mongopile::CORE::Replicasets;

$VERSION = 1.0;

use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

use mongopile::CORE::Replicasets::Member;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
      $self->{ 'error'   } = undef  if !$self->{'error'  };
      $self->{ 'members' } = [] if !$self->{'members'};
      $self->{ 'rsname'  } = undef  if !$self->{'rsname' };
   return $self;
}

sub get_replicaset_status_using_rest {
   my $self = shift;
   my ($host,$port) = (@_);
   $host = 'localhost' unless defined($host);
   $port = '28017'     unless defined($port);
   
   my $replicaset_data = $self->_replSetGetStatus( $host, $port );
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
   return 1;
}

sub rsname     { $_[0]->{'rsname' } = $_[1] if defined ($_[1]); $_[0]->{'rsname'}; }
sub members    { $_[0]->{'members'}; }
sub add_member {
	return unless defined($_[1]);
	return unless ref $_[1] eq 'mongopile::CORE::Replicasets::Member'; 
	push ( $_[0]->members ), $_[1];
	
	print Dumper $_[1];
}

sub _top {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/top', '?' ,'json=1' )
	 );
}

sub _serverStatus {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/serverStatus', '?' ,'json=1' )
	 );
}

sub _listDatabases {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/listDatabases', '?' ,'json=1' )
	 );
}

sub _isMaster {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/isMaster', '?' ,'json=1' )
	 );
}

sub _features {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/features', '?' ,'json=1' )
	 );
}

sub _cursorInfo {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/cursorInfo', '?' ,'json=1' )
	 );
}

sub _buildInfo {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/buildInfo', '?' ,'json=1' )
	 );
}

sub _localSystemReplset {
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/local/system.replset', '?' ,'json=1' )
	 );
}

sub _replSetGetStatus{
	return $_[0]->_make_request( $_[1], $_[2] ,
		join '', ( '/replSetGetStatus', '?' ,'json=1' )
	 );
}


sub _make_request {
  my $self = shift;
  my ($host, $port, $urlpath, $https_flag ) = (@_);
  my $protocol = ( defined($https_flag) ) ? 'https' : 'http';
  my $_UA = new Mojo::UserAgent();              
   
  my $_json_data = $_UA->get( join '', 
   	( $protocol , '://' , $host, ':' , $port, $urlpath)
      )->res->body;
  my $_data = undef;   

   eval { $_data = Mojo::JSON->decode ( $_json_data ); };
   $self->error( $@ ) if $@;
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

package mongopile::CORE::Replicasets;

$VERSION = 1.0;

use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

use mongopile::CORE::Replicasets::Member;
use mongopile::CORE::Replicasets::Member::MongodbBuild;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
      $self->{ 'error'   } = undef  if !$self->{'error'  };
      $self->{ 'members' } = {} if !$self->{'members'};
      $self->{ 'rsname'  } = undef  if !$self->{'rsname' };
   return $self;
}

sub get_replicaset_status_using_rest {
   my $self = shift;
   my ($host,$port) = (@_);
   $host = '127.0.0.1' unless defined($host);
   $port = 27017       unless defined($port);
   
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
               $rs_member = undef;
        }

   #__local.system.replset
   
   foreach my $member ( @{ @{ $self->_localSystemReplset( $host, $port)->{'rows'} }[0]->{'members'} } ){
	
		my $_member_obj = $self->get_member( $member->{'host'} );

        	#___mongodbBuild object
		   	my $build_info = $self->_buildInfo( $self->_split_host_port( $member->{'host'} ) );        	
    		my $mongo_build_obj = $_member_obj->mongodbBuild();
    		   print Dumper $_member_obj;
    		   print Dumper $mongo_build_obj;
    	   	   $mongo_build_obj->version( $build_info->{'version'} );

   		$_member_obj->priority( $member->{'priority'} );
     	#$_member_obj->mongodbBuild( $mongo_build_obj );

     	print Dumper $mongo_build_obj;

   		$self->add_member( $member->{'host'} , $_member_obj );   
  
  }# foreach
  
   return 1;
}


sub add_member {
	return unless defined($_[1]);
	return unless ref $_[1] eq 'mongopile::CORE::Replicasets::Member'; 
	$_[0]->{'members'}->{$_[1]->name} = $_[1];
}

sub _split_host_port { return split ':', $_[1] if defined $_[1]; }

sub members { return keys( %{ $_[0]->{'members'} }); }
sub get_member{ return $_[0]->{'members'}->{ $_[1] } if defined($_[1]); }
sub remove_member { delete $_[0]->{'members'}->{$_[1]} if defined($_[1]); }
sub rsname     { $_[0]->{'rsname' } = $_[1] if defined ($_[1]); $_[0]->{'rsname'}; }

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
		join '', ( '/local/system.replset/', '?' ,'json=1' )
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

     $port += 1000; # rest port
     
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

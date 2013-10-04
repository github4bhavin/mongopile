package mongopile::CORE::Replicasets;
$VERSION = 1.0;

my @PROJECT_DIR;
BEGIN {
use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

   @PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @PROJECT_DIR;
   pop @PROJECT_DIR;
   push @INC, join '/' , @PROJECT_DIR;
};

use Mojo::UserAgent;
use Mojo::JSON;
use mongopile::CORE::Replicasets::Member;
use Data::Dumper;

use mongopile::CORE::Replicasets::Member;
use mongopile::CORE::Replicasets::Member::MongodbBuild;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
<<<<<<< HEAD

      $self->{ 'rs'    } = undef  if !$self->{'rs'    };
      $self->{ 'error' } = undef  if !$self->{'error' };

   return $self;
}

sub _make_request {
  my $self = shift;
  my $url  = shift;
  my $_UA = new Mojo::UserAgent();
  my $_json_data = $_UA->get( $url )->res->body;
  my $_data = undef;

   eval { $_data = Mojo::JSON->decode ( $_json_data ); };
   return $_data;

}

sub get_replSetGetStatus {
   return $_[0]->_make_request (
	join '', ( $_[0]->rs->{ $_[1] }->{'http'} , '://' ,
	           $_[0]->rs->{ $_[1] }->{'host'} , ':'   ,
	           $_[0]->rs->{ $_[1] }->{'port'} ,
               '/replSetGetStatus', '?json=1')
   );
}

sub get_status {
   my $self = shift;
   my $param = {@_};
   if( !$param->{'host'}  || !$param->{'port'} )
     { $self->{'error'} = "no host or port defiend";
       return undef;
     }

    $self->add_rs($_data->{'set'} );
    $self->add_rs_host( $_data->{'set'}, $param->{'host'} );
    $self->add_rs_port( $_data->{'set'}, $param->{'port'} );
	$self->get_replSetGetStatus($_data->{'set'});

        foreach my $member ( @{ $_data->{'members'} } ){
            $self->add_rs_member(
            	new Replicasets::CORE::Replicasets::Member(
            		'memberid' => $member->{ '_id' },
            		'name' => $member->{ 'name' },
            		'healthState' => $member->{ 'health' },
            		'replicasetState' => $member->{ 'stateStr' },
            		'uptime' => $member->{'uptime'},
            		'optime' => $member->{'optimeDate'}->{'$date'},
            		'lastHeartbeat' => $member->{'lastHeartbeat'}->{'$date'},
            		'pingMs' => $member->{'pingMs'},
            		'isMaster' => ,
            		'js' => ,
            		'oidMacine' => ,
            		'localTime' => ,
            ));

=======
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

   $self->__add_local_system_repl_set( $host, $port );
   
   foreach my $member ( $self->get_members ){
        $self->__add_build_info( $self->_split_host_port( $member ) );
		$self->__add_is_master( $self->_split_host_port( $member ) );		  

  }# foreach

   print Dumper $self;
  
   return 1;
}

sub __add_local_system_repl_set {
  my $self = shift;
  my ($host, $port) = (@_);
  my $_member_obj = $self->get_member( "$host:$port" );
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
	      $_member_obj->priority( $member->{'priority'} );
   	      $self->add_member( $member->{'host'} , $_member_obj );
  }# foreach

}

sub __add_is_master {
  my $self = shift;
  my ($host, $port) = (@_);
  my $_member_obj = $self->get_member( "$host:$port" );

  #__ismaster
  my $is_master = $self->_isMaster( $host, $port);
     $_member_obj->isMaster( $is_master->{'ismaster'} );
     
  if (defined (@{ $is_master->{'arbiters'} }[0]) &&
      $is_master->{'me'} eq @{ $is_master->{'arbiters'} }[0] ){
      $_member_obj->arbiter( @{ $is_master->{'arbiters'} }[0] );
  }

  $self->add_member( $host , $_member_obj );
 
}

sub __add_build_info {
  my $self = shift;
  my ($host, $port) = (@_);
  my $_member_obj = $self->get_member( "$host:$port" );

  #___mongodbBuild object
  my $build_info = $self->_buildInfo( $host, $port );
          	
  my $mongo_build_obj = $_member_obj->mongodbBuild;
     $mongo_build_obj->version( $build_info->{'version'} );
     $mongo_build_obj->gitVersion( $build_info->{'gitVersion'} );
     $mongo_build_obj->sysInfo( $build_info->{'sysInfo'} );
     $mongo_build_obj->bits( $build_info->{'bits'} );
     $mongo_build_obj->debug( $build_info->{'debug'} );
     $mongo_build_obj->maxBsonObjectSize( $build_info->{'maxBsonObjectSize'} );    		      		      		      		      		

     $build_info = undef;
     $mongo_build_obj = undef;
  $self->add_member( $host , $_member_obj );
}

sub get_members {
  my $self = shift;
  return keys( %{ $self->{'members'} }); 
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
   
>>>>>>> cf33a3273ba243b535bb013ba32a31dda7f6e2b1
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
<<<<<<< HEAD

sub http    { $_[0]->{'http'   } = $_[1] if defined $_[1]; return $_[0]->{'http'   }; }
sub port    { $_[0]->{'port'   } = $_[1] if defined $_[1]; return $_[0]->{'port'   }; }
sub host    { $_[0]->{'host'   } = $_[1] if defined $_[1]; return $_[0]->{'host'   }; }
sub rs          { return $_[0]->{'rs'};                        }
sub add_rs      { $_[0]->rs->{ $_[1] } = {} if defined $_[1];  }
sub members     { return $_[0]->{'members'};                   }
sub add_rs_host { $_[0]->rs->{ $_[1] }->{ 'host' } = $_[2] if defined ($_[1]) && defined ($_[2]); }
sub add_rs_port { $_[0]->rs->{ $_[1] }->{ 'port' } = $_[2] if defined ($_[1]) && defined ($_[2]); }
sub add_rs_member { push @{ $_[0]->rs->{ $_[1] }->{ 'members' } } , $_[2] if defined ($_[1]) && defined($_[2]); }

sub get_members {
   my $self = shift;
   return undef if !$self->rs_name;
   return ($self->{'rs_data'}->{ $self->rs_name }) ? keys ( %{$self->{ 'rs_data' }->{ $self->rs_name }} ) : undef;
}

sub get_stats_for_member {
   #__cached stats
   my $self = shift;
   my ($host, $port )  = @_;
   return ( $host && $port ) ? $self->{'rs_data'}->{ $self->rs_name }->{ "$host:$port" } : undef;
}

1;
=======
>>>>>>> cf33a3273ba243b535bb013ba32a31dda7f6e2b1

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

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;

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
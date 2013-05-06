package mongopile::CORE::Replicasets;

$VERSION = 1.0;

use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
   
      $self->{ 'host'    } = undef  if !$self->{'host'   };
      $self->{ 'port'    } = 28017  if !$self->{'port'   };
      $self->{ 'http'    } = 'http' if !$self->{'http'   };
      $self->{ 'rs_data' } = undef  if !$self->{'rs_data'};
      $self->{ 'error'   } = undef  if !$self->{'error'  };

   return $self;
}

sub get_status {
   my $self = shift;
   
   if( !$self->{'host'}  || !$self->{'port'} ) 
     { $self->{'error'} = "no host or port defiend";
       return undef; }
              
   my @_RS_URL = ( $self->{'http'} , '://' , $self->{'host'} , ':' , $self->{'port'} ,
                  '/replSetGetStatus', '?json=1');
   my $_UA = new Mojo::UserAgent();
   
   my $_json_data = $_UA->get( join '', @_RS_URL )->res->body;
   my $_data;   

   eval { $_data = Mojo::JSON->decode ( $_json_data ); };
   
   if ($@)
      { $self->{'error'} = $@;
        return undef; }
  else 
      {
        $self->{ 'rs_name' } = $rs_name = $_data->{'set'};
        foreach my $member ( @{ $_data->{'members'} } ){  
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'optime'       } = $member->{'optime'       }->{'i'    } || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'optimeDate'   } = $member->{'optimeDate'   }->{'$date'} || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'lastHeartbeat'} = $member->{'lastHeartbeat'}->{'$date'} || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'health'       } = $member->{'health'       } || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'state'        } = $member->{'state'        } || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'uptime'       } = $member->{'uptime'       } || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'health'       } = $member->{'health'       } || 0;
            $self->{ 'rs_data'}->{ $rs_name }->{ $member->{name} }->{ 'pingMs'       } = $member->{'pingMs'       } || 0;            
        }
        
       $self->host('');
       $self->port('');
       return $_data; 
       }
   
}

sub host {
   my $self = shift;
   my $_new_val = shift;
      $self->{ 'host' } = $_new_val if $_new_val;
   return $self->{ 'host' };
}

sub port {
   my $self = shift;
   my $_new_val = shift;
      $self->{ 'port' } = $_new_val if $_new_val;
   return $self->{ 'port' };
}

sub http {
   my $self = shift;
   my $_new_val = shift;
      $self->{ 'http' } = $_new_val if $_new_val;
   return $self->{ 'http' };
}

sub error {
   my $self = shift;
   return $self->{ 'error' };
}

sub rs_data {
   my $self = shift;
   return $self->{ 'rs_data' };
}

sub rs_name {
   my $self = shift;
   return $self->{ 'rs_name' };
}

sub get_members {
   my $self = shift;
   return keys ( %{$self->{ 'rs_data' }->{ $self->rs_name }} );
}

sub get_stats_for_member {
   #__cached stats 
   my $self = shift;
   my ($host, $port )  = @_;
   return ( $host && $port ) ? $self->{'rs_data'}->{ $self->rs_name }->{ "$host:$port" } : undef;
}

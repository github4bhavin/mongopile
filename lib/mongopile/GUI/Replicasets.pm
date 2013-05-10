package mongopile::GUI::Replicasets;

$VERSION = 1.0;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

sub access {
  my $self = shift;
     $self->session( 'active' => 1 );
	 
	 #__test if SQLite DB exits if not create blank DB Schema
	 $self->db_replicasets->__create_blank_db();

	 return 1;
}


sub get_all {
  my $self = shift;
     $self->redirect_to('/') unless $self->session('active');
       
   my @all_replicasets =  $self->db_replicasets->get_all_replicasets();
      
      if( !@all_replicasets )
        { $self->app->log->warn( "no replicasets found! [". $self->db_replicasets->error ."]" ); }

      $self->app->log->debug( Dumper \@all_replicasets );
      
      $self->render( json => { replicasets => \@all_replicasets });

}

sub add {
  my $self = shift;
  my $new_rs_url = $self->param('newRSName');

     $self->redirect_to('/') unless $self->session('active');
     
  #__check if defiend $new_rs_url
  my ($rs_host,$rs_port) = split ':', $new_rs_url;
     $rs_port = 28017 if !$rs_port;

     $self->render if !$rs_host;
     $self->core_replicasets->host( $rs_host );
     $self->core_replicasets->port( $rs_port );
    
     if(!$self->core_replicasets->get_status())
       { $self->error( $self->core_replicasets->error());}
   

    if( $self->db_replicasets->add_to_replicasets( $self->core_replicasets->rs_name(), 1 ) )
       { }   
   
   $self->app->log->debug( Dumper $self->core_replicasets->rs_data() );
   
   my @rs_members = $self->core_replicasets->get_members();
      
   foreach my $rs_member( @rs_members ){
      my($_rs_host,$_rs_port)  = split ':', $rs_member;

      if( $self->db_replicasets->add_to_mongohost( $self->core_replicasets->rs_name(), $_rs_host,$_rs_port ) )
        { }

      my $stats = $self->core_replicasets->get_stats_for_member( $_rs_host,$_rs_port );
      
      if( $self->db_replicasets->add_to_stats( $_rs_host,$_rs_port,$stats ) )
        { }
        
   }   
  

  if(my $_error = $self->error())
    { $self->render(json => { error => $_error } ); 
      $self->app->log->debug( $_error );
       undef $_error;                                      }
  else
    { $self->render(json => { success => 'success'    } ); }

}

sub get_replicaset_state {
   my $self = shift;
   my $rs_name = $self->param('rs');
   $self->render( json => { 'error' => 'no rs param found!' } ) if !$rs_name;
   my %state = ( 'up' => 0 , 'down' => 0 );
   
   my @members = $self->db_replicasets->get_all_members($rs_name);
   foreach my $member (@members){
       ($self->db_replicasets->get_member_state( $member->{'host'}, $member->{'port'} ) )?
       $state{'up'}++ : $state{'down'}++;
   }
   $self->render( json => \%state  );
}

#_____ All Methods below are specific to replicasets 
#_____ extract information from replicasets
#_____ assumes mongod is running with --rest param.

sub _is_replicaset_present {
   my $self        = shift;
   my $rs_name     = shift;
   my $_rs_db_val  = undef;
   
   eval { 
   $_rs_db_val = $self->db->selectrow_arrayref("SELECT rs_name from replicasets where rs_name='$rs_name'");
   };
   
   if($@)
     { $self->app->log->error("$@ ". $DBI::errstr);
       return undef; }
   if( !defined ( $_rs_db_val ) )
     { $self->app->log->warn("rs not found $rs_name" );
       return undef; }
   if( $rs_name eq $_rs_db_val->[0])    
     { $self->app->log->info("rs found $rs_name" );
       return 1; }
}

sub _get_replicaset_status_from_host {
   my $self = shift;
   my ($_host,$_port) = @_;
   
   if(!$_host || !$_port)
      { $self->app->log->debug("replicaset data : no host or port!");
        return undef; }
        
   my @_RS_URL = ( 'http://', $_host,':', $_port,
                  '/replSetGetStatus', '?json=1');
   my $_UA = new Mojo::UserAgent();
   
   my $_json_data = $_UA->get( join '', @_RS_URL )->res->body;
   my $_data;   

   eval { $_data = Mojo::JSON->decode ( $_json_data ); };
   
   if ($@)
   	  { $self->app->log->error('replSetGetStatus'.$@);
   	    return undef;  }
   else
      { return $_data; }
   
}

sub _add_new_replicaset_to_db {
   my $self = shift;


   
   if(!$self->replicaset->rs_name)
     { $self->app->log->debug("Unable to get replicaset name!");
       $self->{'error'} = 'no replicaset name'; 
       return undef; }    

   if($self->_is_replicaset_present( $self->replicaset->rs_name ) )
     { $self->{'error'} = 'replicaset exists'; 
       return undef; }    
    
   #___insert replicasets  

   eval {   
   $self->db->do( join '' , 
        ( "INSERT INTO replicasets (rs_name,rs_status) VALUES( "   ,
          '"', $self->replicaset->rs_name , '",' ,
          0  ,')'
        ) );

   };

   if($@) 
     { $self->app->log->error ( "$@ ". $DBI::errstr ); 
       $self->{'error'} = 'insert error'; }

   #___ insert mongodb hosts

   foreach my $rs_member ( $self->replicaset->get_members ) {

       my ($host,$port) = split ':', $rs_member;
       
       #__get ReST port
       $port +=1000;

	   $self->app->log->debug( "host : $host , port : $port " );

       eval {
        $self->db->do( join '' , 
             ( "INSERT INTO mongohost (host,port,rs_name) VALUES( ",
               "'$host'" , "," ,
               $port     , "," ,
              "'", $self->replicaset->rs_name , "'" , ")" 
             ) );
        }; 
        
        if($@) 
           { $self->app->log->error ( "$@ ". $DBI::errstr ); 
             $self->{'error'} = 'insert error'; }
       else
           { my $rs_member_data = $self->replicaset->get_stats_for_member( $host, $port-1000 );
             $self->_update_stats_for_member( $host, $port , $rs_member_data ); }
   
   }#foreach
   
   
   $self->___rollback() if $self->{'error'};
    
}

sub ___rollback {
 my $self = shift;
 
    #__ remove replicaset inserted.(roolback);
    eval{ $self->db->do("DELETE FROM replicasets WHERE rs_name='" . $self->replicaset->rs_name ."'"); };
    if($@)
      { $self->app->log->error("unable to rollback insert for ". $self->replicaset->rs_name ); }
   
    #__ remove members for replicaset.(roolback);
    eval{ $self->db->do("DELETE FROM mongohost WHERE rs_name='". $self->replicaset->rs_name  ."'"); };
    if($@)
      { $self->app->log->error("unable to rollback insert for ". $self->replicaset->rs_name  ); }
     
}


sub _update_stats_for_member {
   my $self = shift;
   my ($host,$port, $stats) = @_;
   
   if (!$host || !$port)
     { $self->app->log->debug("not host or port ");
       return undef; }
   
   if (!$stats)
      { $self->app->log->debug("no stats available for $host:$port");
        return undef; } 

   eval{
     $self->db->do(join '',
        ('INSERT INTO stats (host,port,optime,optime_date,last_heart_beat,health,state,ping_ms) VALUES(',
         "'", $host ,"',",
         $port                     , ",",
         $stats->{'optime'       } , ",",
         $stats->{'optimeDate'   } , ",",
         $stats->{'lastHeartbeat'} , ",",
         $stats->{'health'       } , ",",
         $stats->{'state'        } , ",",
         $stats->{'pingMs'       } ,                                                      
         ')' ));
   };

   if($@)
     { $self->app->log->error("$@ ", $DBI::errstr);
       $self->{'error' } = 'stats error'; }
}

sub _replicaset_health_status {
  my $self = shift;
  my $replicaset = shift;
  
     
  
}


sub error {
   my $self = shift;
   my @new_val = @_;
   if ( @new_val ){
       $self->{ 'error' } = $self->{ 'error' } . join ' ', @new_val;
   } else { 
       my $retval  = $self->{'error'};
          $retval .= $self->core_replicasets->error();
          $retval .= $self->db_replicasets->error();
          $self->{ 'error' } = '';
       return $retval ;
   }
}
package mongopile::Replicasets;

$VERSION = 1.0;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::UserAgent;
use Mojo::JSON;

use Data::Dumper;

sub access {
  my $self = shift;
     $self->session( 'active' => 1 );
	 
	 #__test if SQLite DB exits if not create blank DB Schema
	 
    $self->app->log->debug("inside replicaset access ");	 
	 
	 $self-> __sqlite_create_blank_db();
	 return 1;
}

sub get_all {
  my $self = shift;
     $self->redirect_to('/') unless $self->session('active');
  
  $self->render( json => {
		replicasets => [
			'ReplicaSet 1',
			'ReplicaSet 2',
			'ReplicaSet 3',
			'ReplicaSet 4',
			'ReplicaSet 5',												
		]  
  });

}

sub get_replicasets {

}

sub add {
  my $self = shift;
  my $new_rs_url = $self->param('newRSName');

     $self->redirect_to('/') unless $self->session('active');
     
  #__check if defiend $new_rs_url
  my ($rs_host,$rs_port) = split ':', $new_rs_url;
  $rs_port = 28017 if !$rs_port;
  
  $self->app->log->debug ( $new_rs_url  . '| '. $rs_host. '|' . $rs_port );
  
  my $rs_status_data = $self->_get_replicaset_status_from_host( $rs_host,$rs_port );

  $self->_add_new_replicaset_to_db( $rs_status_data );
  
  #$self->app->log->debug ( Dumper $rs_status_data );
  
  $self->render(json => { id => 1 } );

}


#_____ All Methods below are specific to replicasets 
#_____ extract information from replicasets
#_____ assumes mongod is running with --rest param.

sub _get_replicaset_status_from_host {
   my $self = shift;
   my ($_host,$_port) = @_;
   my @_RS_URL = ( 'http://', $_host,':', $_port,
                  '/replSetGetStatus', '?json=1');
   my $_UA = new Mojo::UserAgent();
   
   $self->app->log->debug( "url " . Dumper \@_RS_URL );
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
   my $rs_status_data = shift;
   
}



sub __sqlite_create_blank_db {
  my $self = shift;
  my %___TABLES = (
       "replicasets" => (
          'CREATE TABLE IF NOT EXISTS replicasets (',
             'rs_id INT PRIMARY KEY,',
             'rs_name TEXT',
          ')'
         ),
      
  ); 
  
  my $___SHOW_ALL_TABLES = 'SELECT name FROM sqlite_master where type="table"' ;
  
  #__check if all tables exits ... create the ones that done.
  my @___ALL_EXISTING_TABLES = @{ $self->db->selectall_arrayref( $___SHOW_ALL_TABLES ) };

  $self->app->log->debug ( Dumper \%___TABLES ); 
 
  foreach my $table ( keys %___TABLES ) {
      #if( $___ALL_EXISTING_TABLES)
  }       
 
 
  #$self->db->do( join '' , @___TABLE_REPLICASETS );  
  
}
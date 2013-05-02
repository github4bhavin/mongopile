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
	 
	 $self-> __sqlite_create_blank_db();

	 return 1;
}

sub get_all {
  my $self = shift;
     $self->redirect_to('/') unless $self->session('active');
  my @all_replicasets;
     
    eval { 
       my $_all_replicasets = $self->db->selectall_arrayref( 'SELECT rs_name FROM replicasets' ,{ Slice => {} } ); 
          @all_replicasets   = map { $_->{ rs_name } ;} @$_all_replicasets;
    };
    if($@)
      { $self->app->log->error("$@ ". $DBI::errstr); }
      
      $self->app->log->info( Dumper \@all_replicasets );
      
      $self->render( json => { replicasets => \@all_replicasets  });

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

  $self->render if !$rs_host;
    
  my $rs_status_data = $self->_get_replicaset_status_from_host( $rs_host,$rs_port );

   $self->_add_new_replicaset_to_db( $rs_status_data );
  
  if( $self->{'error'} ){
     $self->stash( error => $self->{'error'} );
     $self->render(json => { error => $self->{'error'} } );
  } else {
     $self->render(json => { success => 'success' } );  
  }

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
   my $rs_status_data = shift;

   if(!$rs_status_data->{'set'})
     { $self->app->log->debug("Unable to get replicaset name!");
       $self->{'error'} = 'no replicaset name'; 
       return undef; }    

   if($self->_is_replicaset_present( $rs_status_data->{'set'} ) )
     { $self->{'error'} = 'replicaset exists'; 
       return undef; }    
    
   #___insert replicasets  

   eval {   
   $self->db->do( join '' , 
        ( "INSERT INTO replicasets (rs_name,rs_status) VALUES( "   ,
          '"', $rs_status_data->{'set'} , '",' ,
          0  ,')'
        ) );

   };

   if($@) 
     { $self->app->log->error ( "$@ ". $DBI::errstr ); 
       $self->{'error'} = 'insert error'; }

   #___ insert mongodb hosts

   foreach my $rs_member ( @{$rs_status_data->{'members'}} ) {

       my ($host,$port) = split ':', $rs_member->{'name'};

       eval {
        $self->db->do( join '' , 
             ( "INSERT INTO mongohost (host,port,rs_name) VALUES( ",
               "'$host'" , "," ,
               $port     , "," ,
              "'", $rs_status_data->{'set'} , "'" , ")" 
             ) );
        }; 
        
        if($@) 
           { $self->app->log->error ( "$@ ". $DBI::errstr ); 
             $self->{'error'} = 'insert error'; }
   
   }#foreach
   
    $self->___rollback($rs_status_data) if $self->{'error'};
    
}

sub ___rollback {
 my $self = shift;
 my $rs_status_data = shift;
 
 #__ remove replicaset inserted.(roolback);
    eval{ $self->db->do("DELETE FROM replicasets WHERE rs_name='".$rs_status_data->{'set'} ."'"); };
    if($@)
      { $self->app->log->error("unable to rollback insert for ". $rs_status_data->{'set'} ); }
      
}


sub __sqlite_create_blank_db {
  my $self = shift;
  my %___TABLES = (
       "replicasets" => [
          'CREATE TABLE IF NOT EXISTS replicasets (',
             'rs_name   TEXT     PRIMARY KEY ,',
             'rs_status INTEGER',
          ')'
         ],
        "mongohost" => [
          'CREATE TABLE IF NOT EXISTS mongohost (',
             'host    TEXT,',
             'port    INTEGER ,',
             'rs_name TEXT,',
             'PRIMARY KEY (host,port),',
             'FOREIGN KEY (rs_name) REFERENCES replicasets(rs_name)',
          ')'
        ],
      
  ); 
  
  foreach my $_table ( keys %___TABLES ) {
     my $___FIND_TABLE = "SELECT name FROM sqlite_master where type='table' and name='$_table'" ;
  
     #__check if all tables exits ... create the ones that done.
     my $_present = $self->db->selectrow_arrayref( $___FIND_TABLE );
     
     if ( defined($_present ) )
        { next if $_present->[0] eq $_table; }
        
     eval { $self->db->do( join ('' , @{$___TABLES{ $_table }} ) ); };
     if( $@ )
       { $self->app->log->error ( "$@", join ('' , @{$___TABLES{ $_table }} ) ); }
       
     if( !$DBI::err )
       { $self->app->log->debug("$_table created!"); }
     else
       { $self->app->log->error("unable to create $_table " . $DBI::errstr ); }
     
  }
 
}
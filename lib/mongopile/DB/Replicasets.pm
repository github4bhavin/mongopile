package mongopile::DB::Replicasets;

use parent 'mongopile::DB';

$VERSION = 1.0;

use Data::Dumper;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
   $self->{'error'} = '';
   return $self;
}

sub get_all_replicasets {
   my $self = shift;
   my @_all_replicasets = ();
   
   eval {
       my $_all_replicasets  = $self->dbh->selectall_arrayref( 'SELECT rs_name FROM replicasets' ,{ Slice => {} } ); 
       @_all_replicasets      = map { $_->{ rs_name } ;} @$_all_replicasets;
    };
    
    if($@)
      { $self->error("$@ ". $DBI::errstr); }
      
   return @_all_replicasets;  
}

sub get_all_members {
   my $self = shift;
   my $rs_name = shift || return;
   my @all_members;
   
   eval {
         my $_all_members  = $self->dbh->selectall_arrayref( "SELECT host,port FROM mongohost WHERE rs_name='$rs_name'" ,{ Slice => {} } );
         @all_members = @{$_all_members} if $_all_members; 
    };
    
    if($@)
      { $self->error("$@ ". $DBI::errstr); }
      
   return @all_members;   
}

sub get_member_state {
   my $self = shift;
   my ($host, $port) = @_;
   my $health = 0;
   eval {
         $health = $self->dbh->selectrow_arrayref( join '', ( 
         "SELECT health FROM stats WHERE ",
         "host='$host' AND port=$port ",
         "ORDER BY timestamp desc LIMIT 1",
         ) ); 
   };
    
   if($@)
     { $self->error("$@ ". $DBI::errstr); } 
   return $health->[0];    
}

sub is_replicaset_present {
   my $self = shift;
   my $rs_name = shift;
   my $_dbrs;
   
   if(!$rs_name)
     { $self->error("no replicaset name given");
       return undef; }

   eval { $_dbrs = $self->dbh->selectrow_arrayref("SELECT rs_name FROM replicasets WHERE rs_name='$rs_name'"); };  
    
   return undef if !$_dbrs;
   
   if($@)
     { $self->error($@);
       return undef; }
       
  return 1;       
}

sub is_member_present {
   my $self = shift;
   my ($host,$port,$rs_name) = (@_);
   my $dbmember;
   
   return undef if ( !$host || !$port || !$rs_name );
   eval {  
   $dbmember = $self->dbh->selectrow_arrayref(
            join "", ("SELECT host,port,rs_name FROM mongohost WHERE host='$host'",
                      " AND port=$port AND rs_name='$rs_name'"                    ));
   };  
   
   return undef if !$dbmember;
      
   if($@)
     { $self->error($@);
       return undef; }
       
  return 1;
   
}

sub is_stats_present_for_member {
   my $self = shift;
   my ($host,$port) = (@_);
   my $dbstats;
   
   return undef if ( !$host || !$port );
   eval { $dbstats = 
          $self->dbh->selectrow_arrayref("SELECT timestamp FROM stats WHERE host='$host' AND port=$port" );  
   };         
   
   return undef if !$dbstats;
   
   if($@)
     { $self->error($@);
       return undef; }
       
  return 1;
   
}


#--- ADD record section

# add_to_replicasets( $rs_name , $rs_status:1 )
sub add_to_replicasets {
   my $self = shift;
   my ($rs_name,$rs_status) = (@_);
   
   $rs_status = 1 if !defined($rs_status);
   
   if(!$rs_name)
     { $self->error("[add_to_replicaset] no replicaset given! ");
       return undef;}
       
   if($self->is_replicaset_present($rs_name))
     { $self->error("[add_to_replicaset] replicaset present in db !");
       return undef; }
       
   eval{ $self->dbh->do( "INSERT INTO replicasets(rs_name,rs_status) VALUES('$rs_name',$rs_status)" ); };
   
   if($@)
     { $self->error("[add_to_replicaset] $@");
       return undef; }
       
   return 1;    
}

sub add_to_mongohost {
   my $self = shift;
   my ($rs_name, $host, $port ) = (@_);
   
   if(!$rs_name)
     { $self->error("[add_to_mongohost] no replicaset given! ");
       return undef;}   
 
   if(!$self->is_replicaset_present($rs_name))
     { $self->error("[add_to_mongohost] replicaset NOT present in db !");
       return undef; }
   
   if(!$host)
     { $self->error("[add_to_mongohost] no host given! ");
       return undef;}   

   if(!$port)
     { $self->error("[add_to_mongohost] no port given! ");
       return undef;}          

   #--- check if host:port:replicaset exists in db.
   
   if($self->is_member_present($host,$port,$rs_name))
      { $self->error("[add_to_mongohost] member already present!");
        return undef;                                             }
        
   eval{ $self->dbh->do( "INSERT INTO mongohost(host,port,rs_name) VALUES('$host',$port,'$rs_name')" ); };
   
   if($@)
     { $self->error("[add_to_mongohost] $@");
       return undef; }
       
   return 1;       
}

sub add_to_stats {
   my $self = shift;
   my ($host,$port,$stats) = (@_);

   if(!$host)
     { $self->error("[add_to_stats] no host given! ");
       return undef;}   

   if(!$port)
     { $self->error("[add_to_stats] no port given! ");
       return undef;}
                 
   if(!$stats)
     { $self->error("[add_to_stats] no stats given! ");
       return undef;}

   if($self->is_stats_present_for_member($host,$port) )
     { $self->error("[add_to_stats] stats present! "); }
     
   eval{ $self->dbh->do( 
       join "" , ( "INSERT INTO stats(host,port,optime,optime_date,last_heart_beat,health,state,ping_ms,timestamp) VALUES( ",
                   "'$host'"                  , ",", 
                     $port                    , ",",
                     $stats->{'optime'       }, ",",
                     $stats->{'optimeDate'   }, ",",
                     $stats->{'lastHeartbeat'}, ",",
                     $stats->{'health'       }, ",",
                     $stats->{'state'        }, ",",
                     $stats->{'pingMs'       }, ",",
                     localtime()              , ")"
                  ) ); 
       };
 
   if($@)
     { $self->error("[add_to_stats] $@");
       return undef; }
       
   return 1;
}

#---- REMOVE methods

sub _remove_replicaset {
   my $self = shift;
   my $rs_name = shift || return undef;
   
   eval{ $self->dbh->do( "DELETE FROM replicasets WHERE rs_name='$rs_name'" ); };
   
   if($@)
     { $self->error("[_remove_replicaset] $@");
       return undef; }
       
   return 1;       
}

sub _remove_all_members_for_replicaset {
   my $self = shift;
   my $rs_name = shift || return undef;

   eval{ $self->dbh->do( "DELETE FROM mongohost WHERE rs_name='$rs_name'" ); };
   
   if($@)
     { $self->error("[_remove_all_members_for_replicasets] $@");
       return undef; }
       
   return 1;   
}

sub _remove_member {
   my $self = shift;
   my ($rs_name,$rs_host,$rs_port) = (@_);
   
   return if (!$rs_host || !$rs_port);

   eval{ $self->dbh->do( "DELETE FROM mongohost WHERE host='$rs_host' AND port=$rs_port AND rs_name='$rs_name'" ); };
   
   if($@)
     { $self->error("[_remove_member] $@");
       return undef; }
   return 1;       
}

sub _remove_stats_for_member {
 my $self = shift;
   my ($rs_host,$rs_port) = (@_);
   
   return if (!$rs_host || !$rs_port);

   eval{ $self->dbh->do( "DELETE FROM stats WHERE host='$rs_host' AND port=$rs_port" ); };
   
   if($@)
     { $self->error("[_remove_stats_for_member] $@");
       return undef; }
   return 1;  
}

#--- CREATE TABLEs section
sub __create_blank_db {
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
        "stats" => [
          'CREATE TABLE IF NOT EXISTS stats (',
              'host TEXT ,',
              'port INTEGER ,',
              'optime INTEGER ,',
              'optime_date INTEGER ,',
              'last_heart_beat INTEGER ,',
              'health INTEGER ,',
              'state INTEGER ,',
              'ping_ms INTEGER ,',
              'timestamp INTEGER,',
              'PRIMARY KEY(host,port,timestamp)',
          ')'
        ],
      
  ); 
  
  foreach my $_table ( keys %___TABLES ) {
     my $___FIND_TABLE = "SELECT name FROM sqlite_master where type='table' and name='$_table'" ;
  
     #__check if all tables exits ... create the ones that done.
     my $_present = $self->dbh->selectrow_arrayref( $___FIND_TABLE );
     
     if ( defined($_present ) )
        { next if $_present->[0] eq $_table; }
        
     eval { $self->dbh->do( join ('' , @{$___TABLES{ $_table }} ) ); };
     if( $@ )
       { $self->error ( "$@", join ('' , @{$___TABLES{ $_table }} ) ); }
       
     if( !$self->dbh->err )
       { $self->error("$_table created!"); }
     else
       { $self->error("unable to create $_table " . $DBI::errstr ); }
     
  }
 
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
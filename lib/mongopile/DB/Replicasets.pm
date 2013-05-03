package mongopile::DB::Replicasets;

use parent 'mongopile::DB';

$VERSION = 1.0;

use Data::Dumper;

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
   $self->{'error'} = '';
   #$self->{'dbh'} = $self->dbh();
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
              'PRIMARY KEY(host,port)',
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
       
     if( !$DBI::err )
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
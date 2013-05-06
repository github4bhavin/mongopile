package mongopile::DB;

$VERSION = 1.0;

use DBI;
use Data::Dumper;

my $DBFILE   = join '/', @BASEDIR , 'data', 'mongopile.sqlite';

sub new {
   my $class = shift;
   my $self  = {@_};
   bless $self, $class;
   $self->{ 'DBFILE' } = $DBFILE;
   $self->{ 'dbh'    } = undef;
   $self->_connection();
   
   return $self;
}

sub _connection {
    if(!$_[0]->{'dbh'}) {
       eval {
	    $_[0]->{'dbh'} = DBI->connect( "dbi:SQLite:". $self->{ 'DBFILE' } ,"" ,"" ,
	                                   { RaiseError => 1, PrintError => 1} );
	   };
	   $self->error ( $@ ) if $@;
    }

   return $_[0]->{'dbh'};
}

sub dbh {
   my $self = shift;
   return $self->_connection();
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
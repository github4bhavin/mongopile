package mongopile::DB;

$VERSION = 1.0;

use DBI;
use Data::Dumper;

use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

my @BASEDIR;

BEGIN {
   @BASEDIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @BASEDIR;
   pop @BASEDIR;
};
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
   my $self = shift;
    if(!$self->{'dbh'}) {
       eval {
	    $self->{'dbh'} = DBI->connect( "dbi:SQLite:". $self->get_dbfile() ,"" ,"" ,
	                                   { RaiseError => 1, PrintError => 1} );
	   };
	 if ($@) {
	   $self->error( $@ );
	   $self->error( $self->get_dbfile() );
	 }
	   
    }

   return $self->{'dbh'};
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

sub get_dbfile { 
   my $self = shift;
   $self->{'DBFILE'} = $DBFILE if !$self->{'DBFILE'}; 
   return $self->{'DBFILE'};
}
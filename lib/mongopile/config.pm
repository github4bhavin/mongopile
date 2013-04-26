package mongopile::config;

$VERSION = 1.0;

sub new {
 my $class = shift;
 my $self  = {};
 
   #___ Config Variables
   $self->{ 'DB_TYPE' } = 'sqlite';
   $self->{ 'SQLITE' }->{ 'DATABASE_NAME' } = 'mongopile'; 
 
  bless $self, $class;
  
  return $self;

};
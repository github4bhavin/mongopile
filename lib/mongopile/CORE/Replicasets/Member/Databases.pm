package mongopile::CORE::Replicasets::Member::Databases;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'totalSize'} = undef unless defined $self->{'totalSize'};
  if ( ref $self->{'databases'} ne 'mongopile::CORE::Replicasets::Member::Database')
  {
     push @{$self->{'databases'}} , new mongopile::CORE::Replicasets::Member::Database();
  }
  return $self;
}

sub totalSize { $_[0]->{'totalSize' } = $_[1] if defined ($_[1]); return $_[0]->{'totalSize' };  }
sub databases { $_[0]->{'databases' } = $_[1] if defined ($_[1]); return $_[0]->{'databases' };  }

1;
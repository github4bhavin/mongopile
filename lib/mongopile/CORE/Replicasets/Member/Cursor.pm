package mongopile::CORE::Replicasets::Member::Cursor;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  
  $self->{ 'totalOpen'       } = 0 unless $self->{'totalOpen'      };
  $self->{ 'clientCursorSize'} = 0 unless $self->{'clientCursorSize'};
  $self->{ 'timedOut'        } = 0 unless $self->{'timedOut'        };
  return $self;
}

1;
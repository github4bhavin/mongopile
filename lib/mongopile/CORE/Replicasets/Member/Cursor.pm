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

sub totalOpen        { $_[0]->{'totalOpen'        } = $_[1] if defined ($_[1]); return $_[0]->{'totalOpen'        };  }
sub clientCursorSize { $_[0]->{'clientCursorSize' } = $_[1] if defined ($_[1]); return $_[0]->{'clientCursorSize' };  }
sub timedOut         { $_[0]->{'timedOut'         } = $_[1] if defined ($_[1]); return $_[0]->{'timedOut'         };  }
1;
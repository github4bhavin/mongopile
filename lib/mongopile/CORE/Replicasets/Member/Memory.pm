package mongopile::CORE::Replicasets::Member::Memory;

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'bits'           } = undef unless defined $self->{'bits'            };
  $self->{'resident'       } = undef unless defined $self->{'resident'        };
  $self->{'virtual'        } = undef unless defined $self->{'virtual'         };
  $self->{'supported'      } = undef unless defined $self->{'supported'       };
  $self->{'mapped'         } = undef unless defined $self->{'mapped'          };
  $self->{'heap_usage_byes'} = undef unless defined $self->{'heap_usage_bytes'};
  $self->{'page_faults'    } = undef unless defined $self->{'page_faults'     };
  return $self;
}

1;

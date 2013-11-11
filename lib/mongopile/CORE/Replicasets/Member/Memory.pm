package mongopile::CORE::Replicasets::Member::Memory;

$mongopile::CORE::Replicasets::Member::Memory::VERSION = '1.0';

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  $self->{'bits'           } = undef unless defined $self->{'bits'            };
  $self->{'resident'       } = undef unless defined $self->{'resident'        };
  $self->{'virtual'        } = undef unless defined $self->{'virtual'         };
  $self->{'supported'      } = undef unless defined $self->{'supported'       };
  $self->{'mapped'         } = undef unless defined $self->{'mapped'          };
  $self->{'heap_usage_bytes'} = undef unless defined $self->{'heap_usage_bytes'};
  $self->{'page_faults'    } = undef unless defined $self->{'page_faults'     };
  return $self;
}

sub bits             { $_[0]->{'bits'            } = $_[1] if defined ($_[1]); return $_[0]->{'bits'            }; }
sub resident         { $_[0]->{'resident'        } = $_[1] if defined ($_[1]); return $_[0]->{'resident'        }; }
sub virtual          { $_[0]->{'virtual'         } = $_[1] if defined ($_[1]); return $_[0]->{'virtual'         }; }
sub supported        { $_[0]->{'supported'       } = $_[1] if defined ($_[1]); return $_[0]->{'supported'       }; }
sub mapped           { $_[0]->{'mapped'          } = $_[1] if defined ($_[1]); return $_[0]->{'mapped'          }; }
sub heap_usage_bytes { $_[0]->{'heap_usage_bytes'} = $_[1] if defined ($_[1]); return $_[0]->{'heap_usage_bytes'}; }
sub page_faults      { $_[0]->{'page_faults'     } = $_[1] if defined ($_[1]); return $_[0]->{'page_faults '    }; }

1;

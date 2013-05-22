package mongopile::StatsCollector;
$VERSION = 1.0;

#--------------------------------------------------------------------#
# Project : mongopile                                                #
# Author  : Bhavin Patel                                             #
# Purpose : Collect stats for all replicasets                        #
#--------------------------------------------------------------------#

use File::Basename          qw { dirname          };
use File::Spec::Functions   qw { splitdir rel2abs };

use mongopile::DB;
use mongopile::CORE::Replicasets; 
use mongopile::DB::Replicasets;
use Storable qw { freeze thaw };

use Data::Dumper;

use threads ( 'yield',
              'stack_size' => 64 * 4096,
              'exit'       => 'thread_only',
              'stringify' );

my @BASEDIR;

BEGIN {
   @BASEDIR = ( splitdir ( rel2abs( dirname( __FILE__ ) ) ) );
   pop @BASEDIR;
};

sub new {
  my $class = shift;
  my $self  = {@_};
  bless $self , $class;
  return $self;
}

sub get_status_for_all_replicasets {
    my $self = shift;
    my $db_replicasets_obj = new mongopile::DB::Replicasets();
    my @all_replicasets = $db_replicasets_obj->get_all_replicasets();

    foreach my $rs_name ( @all_replicasets ){
       my @mp_threads;
       my @_results;
 
       my $all_members = $db_replicasets_obj->get_all_members( $rs_name );
       foreach my $member ( @$all_members) {
          push @mp_threads, threads->create( $self->can('_t_update_member_stats') , $member->{'host'}, $member->{'port'});
       }     

       map { @_results = $_->join(); } @mp_threads;
    }
    return 1; 
}

#----- THREADS

sub _t_update_member_stats {
   my ($host,$port) = (@_);
   my $core_replicasets_obj = new mongopile::CORE::Replicasets();
   my $db_replicasets_obj   = new mongopile::DB::Replicasets();
   
      $core_replicasets_obj->host($host);
      $core_replicasets_obj->get_status();
      
   my $stats = $core_replicasets_obj->get_stats_for_member($host,$port);
   return undef if !$stats;
   return $db_replicasets_obj->add_to_stats($host,$port,$stats);
       
}

1;
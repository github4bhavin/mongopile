#!/usr/bin/perl

use Test::More;

use Data::Dumper;

use File::Basename        qw { dirname           };
use File::Spec::Functions qw { splitdir  rel2abs };

my @_PROJECT_DIR;

BEGIN {
   @_PROJECT_DIR = splitdir( dirname( rel2abs( __FILE__ ) ) );
   pop @_PROJECT_DIR;
   pop @_PROJECT_DIR;
   push @INC , join '/', @_PROJECT_DIR , 'lib';
   push @INC , join '/', @_PROJECT_DIR , 'mongopile';
   push @INC , join '/', @_PROJECT_DIR , 'DB';      
};

my @methods = ( 'new'                        ,
                'get_all_replicasets'        , 
                'is_replicaset_present'      ,
                'is_member_present'          ,
                'is_stats_present_for_member',
                'add_to_replicasets'         ,
                'add_to_mongohost'           ,
                'add_to_stats'               ,
                '__create_blank_db'          ,
                'error'                      );

my $_dummy_data = { 'dummy' => {
                             'dummy_host:1234' => {
                                         'optime'        => 0,
                                         'optimeDate'    => 0,
                                         'lastHeartbeat' => '123456789',
                                         'uptime'        => 0,
                                         'pingMs'        => 0,
                                         'health'        => 0,
                                         'state'         => 0
                                         }
                                    }
                       };

use_ok( 'mongopile::DB::Replicasets' );
my $obj = new_ok( 'mongopile::DB::Replicasets' );

can_ok( $obj->dbh , 'selectall_arrayref' );

#__methods exist check
map { can_ok( $obj , $_) } @methods;

#___ CREATE DB if not exist

diag $obj->error() unless ok( $obj->__create_blank_db() ,"create blank db " );

#___FUNCTIONAL TEST

diag $obj->error() unless ok( $obj->add_to_replicasets( 'dummy', 1    ) ,'insert replicasets' );

ok( $obj->add_to_mongohost( 'dummy', 'dummy_host', 1234 ) , 'insert mongohost');
ok( $obj->add_to_mongohost( 'dummy', 'dummy_host2', 1234 ) , 'insert mongohost');

ok( $obj->add_to_stats('dummy_host',1234,$_dummy_data->{'dummy'}->{'dummy_host:1234'} ) ,'insert stats');
ok( $obj->add_to_stats('dummy_host2',1234,$_dummy_data->{'dummy'}->{'dummy_host:1234'} ) ,'insert stats');

ok( $obj->_remove_replicaset('dummy'), 'remove replicaset dummy');

ok( $obj->_remove_member('dummy','dummy_host',1234 ) ,'remove dummy_host from dummy' );
ok( $obj->_remove_all_members_for_replicaset('dummy' ) ,'remove all members for dummy' );

ok( $obj->_remove_stats_for_member( 'dummy_host', 1234 ) ,'remove stats for dummy_host');
ok( $obj->_remove_stats_for_member( 'dummy_host2', 1234 ) ,'remove stats for dummy2_host');

done_testing();
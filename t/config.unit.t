use strict;
use warnings;
use Test::More;
use DBIx::Rainy::Config;

can_ok "DBIx::Rainy::Config", qw(
    get
    add_connect_info
    add_cluster
);

done_testing;


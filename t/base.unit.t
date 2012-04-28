use strict;
use warnings;
use Test::More;
use DBIx::Rainy::Base;

can_ok "DBIx::Rainy::Base", qw(
    new
    connect
    resolver
    _require
);

done_testing;


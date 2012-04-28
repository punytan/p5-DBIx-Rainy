use strict;
use warnings;
use Test::More;
use Test::mysqld;
use t::Model;

subtest "basic usage" => sub {
    my $model = t::Model->new;
    isa_ok $model, "t::Model";
    is_deeply $model->fetch_user, [
        { id => 1, name => "foo" },
        'SQLite',
    ];
};

done_testing;


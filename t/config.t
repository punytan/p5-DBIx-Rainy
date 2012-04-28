use strict;
use warnings;
use Test::More;
use DBIx::DBHResolver;
use t::Config;

my $config = t::Config->get;

subtest "generate a structure for dbhresolver" => sub {
    is_deeply $config, +{
        clusters => {
            diary_master => {
                nodes => [ qw/ diary_master_1 diary_master_2 diary_master_3 / ],
                strategy => "Key",
            },
            user_master => {
                nodes => [ qw/ user_master_1 user_master_2 user_master_3 / ],
                strategy => "Key",
            },
        },
        connect_info => {
            user_master_1 => { dsn => "user_1", user => "", password => "", attrs => {} },
            user_master_2 => { dsn => "user_2", user => "", password => "", attrs => {} },
            user_master_3 => { dsn => "user_3", user => "", password => "", attrs => {} },
            diary_master_1 => { dsn => "diary_1", user => "", password => "", attrs => {} },
            diary_master_2 => { dsn => "diary_2", user => "", password => "", attrs => {} },
            diary_master_3 => { dsn => "diary_3", user => "", password => "", attrs => {} },
            foo => { dsn => "foo", user => "", password => "", attrs => {} },
            bar => { dsn => "bar", user => "", password => "", attrs => {} },
            t_model => {
                dsn => "dbi:SQLite:dbname=:memory:",
                user => "", password => "",
                attrs => { RaiseError => 1, AutoCommit => 1 }
            },
        },
    };
};

subtest "integration" => sub {
    my $r = DBIx::DBHResolver->new;

    ok $r->config($config);

    is ref $r->connect_info('user_master', { strategy => "Key" , key => 1 }), ref {};

    is_deeply $r->connect_info('user_master', [4]), {
        dsn => "user_2", user => "", password => "", attrs => {}
    };

    is_deeply { $r->resolve_node_keys("user_master", [ 0 .. 10 ]) }, {
        'user_master_1' => [ 0, 3, 6, 9 ],
        'user_master_2' => [ 1, 4, 7, 10 ],
        'user_master_3' => [ 2, 5, 8 ]
    };
};

done_testing;

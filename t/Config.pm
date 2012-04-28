package t::Config;
use strict;
use warnings;
use parent 'DBIx::Rainy::Config';

__PACKAGE__->add_connect_info(
    foo => { dsn => "foo", user => "", password => "", attrs => {} }
);

__PACKAGE__->add_cluster(
    diary_master => {
        strategy => "Key",
        nodes => [
            1 => { dsn => "diary_1", user => "", password => "", attrs => {} },
            2 => { dsn => "diary_2", user => "", password => "", attrs => {} },
            3 => { dsn => "diary_3", user => "", password => "", attrs => {} },
        ],
    }
);

__PACKAGE__->add_connect_info(
    bar => { dsn => "bar", user => "", password => "", attrs => {} }
);

__PACKAGE__->add_cluster(
    user_master => {
        strategy => "Key",
        nodes => [
            1 => { dsn => "user_1", user => "", password => "", attrs => {} },
            2 => { dsn => "user_2", user => "", password => "", attrs => {} },
            3 => { dsn => "user_3", user => "", password => "", attrs => {} },
        ],
    }
);

__PACKAGE__->add_connect_info(
    t_model => {
        dsn => "dbi:SQLite:dbname=:memory:",
        user => "",
        password => "",
        attrs => {
            RaiseError => 1,
            AutoCommit => 1,
        },
    }
);

1;

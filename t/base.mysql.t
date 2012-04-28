package t::Model::Config;
use strict;
use warnings;
use parent 'DBIx::Rainy::Config';

use Test::mysqld;
use Test::More;

my $mysqld = Test::mysqld->new(
    my_cnf => { 'skip-networking' => '' }
) or plan skip_all => $Test::mysqld::errstr;

__PACKAGE__->add_connect_info(
    t_model => {
        dsn => $mysqld->dsn(dbname => 'test'),
        user => "", password => "",
        attrs => {
            RaiseError => 1,
            AutoCommit => 1,
        },
    }
);

package main;
use strict;
use warnings;
use Test::More;
use t::Model;

subtest "alter config class (testing with Test::mysqld)" => sub {
    t::Model->config_class("t::Model::Config");
    my $model = t::Model->new;
    is_deeply $model->fetch_user, [
        { id => 1, name => "foo" },
        'mysql',
    ];
};

done_testing;


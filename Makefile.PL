use inc::Module::Install;
name 'DBIx-Rainy';
all_from 'lib/DBIx/Rainy.pm';

# requires '';
requires 'DBIx::Connector';
requires 'DBIx::DBHResolver';
requires 'SQL::Maker';
test_requires 'Test::mysqld';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

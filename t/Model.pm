package t::Model;
use strict;
use warnings;
use parent 'DBIx::Rainy::Base';

__PACKAGE__->config_class("t::Config");

sub fetch_user {
    my ($self, %args) = @_;
    $self->connect("t_model")->txn(
        fixup => sub {
            my $dbh = shift;
            $dbh->do("create table users ( id integer, name text )");
            $dbh->do("insert into users ( id, name ) values ( 1, 'foo' )");
            return [
                $dbh->selectrow_hashref("select * from users where id = ?", {}, 1),
                $dbh->{Driver}{Name},
            ];
        }
    );
}

1;

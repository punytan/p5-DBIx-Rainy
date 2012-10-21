package DBIx::Rainy::Query;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    bless {
        sql  => $args{sql},
        conn => $args{conn},
    }, $class;
}

sub conn { shift->{conn} }
sub sql  { shift->{sql}  }

sub selectrow_hashref {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->select(@args);
    $self->conn->run(fixup => sub { shift->selectrow_hashref($stmt, undef, @bind) });
}

sub selectall_arrayref {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->select(@args);
    $self->conn->run(fixup => sub { shift->selectall_arrayref($stmt, { Slice => {} }, @bind) });
}

sub selectrow_array {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->select(@args);
    $self->conn->run(fixup => sub { shift->selectrow_array($stmt, undef, @bind) });
}

sub insert {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->insert(@args);
    $self->conn->txn(
        fixup => sub {
            my $dbh = shift;
            $dbh->do($stmt, undef, @bind);
            unless ($dbh->{AutoCommit}) {
                $dbh->commit;
            }
            $dbh;
        }
    );
}

sub update {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->update(@args);
    $self->conn->txn(
        fixup => sub {
            my $dbh = shift;
            $dbh->do($stmt, undef, @bind);
            unless ($dbh->{AutoCommit}) {
                $dbh->commit;
            }
        }
    );
}

sub delete {
    my ($self, @args) = @_;
    my ($stmt, @bind) = $self->sql->delete(@args);
    $self->conn->txn(
        fixup => sub {
            my $dbh = shift;
            $dbh->do($stmt, undef, @bind);
            unless ($dbh->{AutoCommit}) {
                $dbh->commit;
            }
        }
    );
}

1;
__END__

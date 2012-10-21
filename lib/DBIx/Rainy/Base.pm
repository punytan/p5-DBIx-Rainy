package DBIx::Rainy::Base;
use strict;
use warnings;

use DBIx::Connector;
use DBIx::DBHResolver;
use DBIx::Rainy::Query;

use SQL::Maker;
SQL::Maker->load_plugin('InsertMulti');

our $ConfigClass = "";

our $DBI = 'DBIx::Connector';
our $DBI_CONNECT_METHOD = 'new';
our $DBI_CONNECT_CACHED_METHOD = 'new';

$DBIx::DBHResolver::DBI = $DBI;
$DBIx::DBHResolver::DBI_CONNECT_METHOD = $DBI_CONNECT_METHOD;
$DBIx::DBHResolver::DBI_CONNECT_CACHED_METHOD =  $DBI_CONNECT_CACHED_METHOD;

my %instances;

sub config_class {
    @_ == 2 ? $ConfigClass = $_[1] : $ConfigClass;
}

sub new {
    my ($class, %args) = @_;

    if ($ConfigClass) {
        _require($ConfigClass);
    } else {
        Carp::croak "calling config_class is required before `new`";
    }

    my $resolver_conf = $ConfigClass->get();

    my $resolver = DBIx::DBHResolver->new;
    $resolver->config($resolver_conf);

    my $driver = $args{sql_driver} || 'mysql';
    my $maker = SQL::Maker->new(driver => $driver);

    return bless {
        sql => $maker,
        resolver => $resolver,
    }, $class;
}

sub connect { shift->{resolver}->connect(@_) }

sub resolver { shift->{resolver} }

sub sql { shift->{sql} }

sub query {
    my $self = shift;

    DBIx::Rainy::Query->new(
        conn => $self->connect(@_),
        sql  => $self->sql,
    );
}

sub register {
    my ($self, $class, @args) = @_;

    unless (exists $instances{$class}) {
        _require($class);
        $instances{$class} = $class->new(@args);
    }

    return $instances{$class};
}

sub _require {
    my $class = shift;

    unless ($class->can("get")) {
        $class =~ s|::|/|g;
        require "$class.pm"; ## no critic
    }
}

1;

__END__

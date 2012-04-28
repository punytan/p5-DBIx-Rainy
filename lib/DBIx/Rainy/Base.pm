package DBIx::Rainy::Base;
use strict;
use warnings;

use DBIx::Connector;
use DBIx::DBHResolver;

our $ConfigClass = "";

our $DBI = 'DBIx::Connector';
our $DBI_CONNECT_METHOD = 'new';
our $DBI_CONNECT_CACHED_METHOD = 'new';

$DBIx::DBHResolver::DBI = $DBI;
$DBIx::DBHResolver::DBI_CONNECT_METHOD = $DBI_CONNECT_METHOD;
$DBIx::DBHResolver::DBI_CONNECT_CACHED_METHOD =  $DBI_CONNECT_CACHED_METHOD;

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

    return bless { resolver => $resolver }, $class;
}

sub connect { shift->{resolver}->connect(@_) }

sub resolver { shift->{resolver} }

sub _require {
    my $class = shift;

    unless ($class->can("get")) {
        $class =~ s|::|/|g;
        require "$class.pm"; ## no critic
    }
}

1;

__END__

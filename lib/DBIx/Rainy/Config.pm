package DBIx::Rainy::Config;
use strict;
use warnings;
use DBIx::DBHResolver;

our $CONFIG = {
    clusters => {},
    connect_info => {},
};

sub add_cluster {
    my ($class, $cluster_name, $opts) = @_;

    my (@nodes, @node_names);
    while (my ($node, $connect_info) = splice @{ $opts->{nodes} }, 0, 2) {
        my $node_name = sprintf "%s_%s", $cluster_name, $node;

        __PACKAGE__->add_connect_info($node_name, $connect_info);
        push @node_names, $node_name;
        push @nodes, $node;
    }

    delete $opts->{nodes};

    $CONFIG->{clusters}{$cluster_name} ||= {
        nodes => [ @node_names ],
        %$opts,
    };

}

sub add_connect_info {
    my ($class, $name, $value) = @_;
    $CONFIG->{connect_info}{$name} = $value;
}

sub get { $CONFIG }

1;

__END__

package Graph::D3;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Moo;
use JSON;
use Graph;

has graph => (
    is => 'ro',
    required => 1
);

has type => (
    is => 'ro',
    default => sub { 'ref' },
);

# https://gist.github.com/mbostock/4062045
# http://bl.ocks.org/mbostock/4062045
sub force_directed_graph {
    my $self = shift;
    my @nodes;
    my %nodes;
    my $counter = 0;
    for my $vertex ($self->graph->vertices) {
        my $group = $self->graph->get_vertex_attribute($vertex, 'group');
        $group = 1 unless (defined $group);
        push @nodes, { name => $vertex, group => $group };
        $nodes{$vertex} = $counter;
        $counter++;
    }
    my @links;
    for my $edges ($self->graph->edges) {
        my ($n1, $n2) = @$edges;
        my $value = $self->graph->get_edge_attribute($n1, $n2, 'value');
        $value = 1 unless (defined $value);
        push @links, {source => $nodes{$n1}, target => $nodes{$n2}, value => $value};
    }
    my $output =  { nodes => \@nodes, links => \@links };
    return $self->type eq 'json' ? encode_json $output : $output;
}


1;
__END__

=encoding utf-8

=head1 NAME

Graph::D3 - Create ref/json to show node-edge graph with D3.js 

=head1 SYNOPSIS

  use Graph;
  use Graph::D3;
  
  my $g = new Graph(
      vertices => [qw/1 2 3 4 5/], 
      edges => [[qw/1 2/], [qw/2 3/], [qw/3 5/], [qw/4 1/]] 
  );
  my $d3 = new Graph::D3(graph => $g);
  $output = $d3->force_directed_graph(); #output is hash reference
  $d3 = new Graph::D3(graph => $g, type => json); 
  $json = $d3->force_directed_graph(); # output is json format
  

=head1 DESCRIPTION

Graph::D3 is a moudle to covert Graph object to the format which is used in d3.js(http://d3js.org/).
This module simply supports node-edge graph in the example.

=head1 METHODS

=head2 force_directed_graph 

This outputs the format which is used for Force Directed Graph described below.

https://gist.github.com/mbostock/4062045
http://bl.ocks.org/mbostock/4062045

The graph should be directed grpah.
Node in Graph can have group attribute (Default is all 1) to have different node color.
Also Edge in Graph can have value attribe(defalut is all 1) to have different length of edge.

=head1 AUTHOR

Shohei Kameda E<lt>shoheik@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Shohei Kameda

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

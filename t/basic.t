use strict;
use Test::More;
use Graph;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Data::Dumper;
use JSON;

use_ok 'Graph::D3';

my $g = new Graph(
    vertices => [qw/1 2 3 4 5/], 
    edges => [[qw/1 2/], [qw/2 3/], [qw/3 5/], [qw/4 1/]] 
);

my $d3 = new Graph::D3(graph => $g);
is($d3->type, 'ref', 'type ok');
my $output = $d3->force_directed_graph();
is(scalar @{$output->{nodes}}, 5, 'number of node is ok');
is(scalar @{$output->{links}}, 4, 'number of link is ok');

$d3 = new Graph::D3(graph => $g, type => 'json');
my $json = $d3->force_directed_graph();
$output =  decode_json $json;
is(scalar @{$output->{nodes}}, 5, 'number of node in json is ok');
is(scalar @{$output->{links}}, 4, 'number of link in json is ok');

done_testing;

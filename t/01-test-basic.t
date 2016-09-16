use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

my $file = 't/html/table.html';

open ( my $fh, '<', $file ) or croak "could not open file: $file"; 
my $html = do { local $/; <$fh> };
close $fh;

my $t = HTML::TableContent->new();
warn Dumper $t;
$t->parse($html);

is ($t->table_count, 1, "correct table count 1");

warn Dumper $t->tables;

1;

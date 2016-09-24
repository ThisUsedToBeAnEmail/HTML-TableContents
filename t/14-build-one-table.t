use strict;
use warnings;

use Test::More;

use Data::Dumper;

BEGIN {
    use_ok('HTML::TableContent');
}

my $t = HTML::TableContent->new();

my $table = $t->add_table({});

warn Dumper $table;

$table->style('width:100%;');
$table->id('hello');
$table->class('something');
$table->add_style('font-size:10px;');

warn Dumper $table;

my $row = $table->add_row({ style => 'width 100%;', id => 'first-row', class => 'odd' });

warn Dumper $row;

my $cell = $row->add_cell({ style => 'width:33%;', id => 'first-cell', class => 'even', text => 'something' });
$cell->add_text('hello');

warn Dumper $cell;

warn Dumper $table;

done_testing();
1;

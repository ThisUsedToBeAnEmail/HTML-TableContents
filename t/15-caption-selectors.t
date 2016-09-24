use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('HTML::TableContent');
}

use Data::Dumper;

my $tc = HTML::TableContent->new();

$tc->add_caption_selectors(qw/h3/);

$tc->parse_file('t/html/horizontal/facebook.html');

is($tc->table_count, 17, "correct table count");

is($tc->get_first_table->caption->text, 'Fields', "expected caption text: Fields");

is($tc->get_table(1)->caption->text, 'Edges', "exptect caption text: Edges");

is($tc->get_table(2)->caption->text, 'Validation Rules', "expected caption text: Validation Rules");

is($tc->get_table(3)->caption->text, 'Validation Rules', "expected caption text: Validation Rules");

is($tc->get_table(4)->caption->text, 'Parameters', "expected caption text: Parameters");

ok(my $table = $tc->get_first_table, "okay get first table");

is($table->row_count, 55, "expected row count: 55");

ok(my $row = $table->get_row(0), "okay get first row");

is($row->cell_count, 2, "expected cell count");

ok($row->clear_last_cell, "drop one cell");

is($row->cell_count, 1, "correct cell count");

ok( $table->clear_first_row, "drop the first row" );

is($table->row_count, 54, "rowcount one less than before: 54");

ok($row = $table->get_last_row, "get the next row" );

is($row->cell_count, 2, "corrent cell count 2"); 

ok($row->clear_first_cell, "okay clear first cell");

is($row->cell_count, 1, "correct cell count 1");

ok($table->clear_last_row, "drop the last row from the table");

is($table->row_count, 53, "row count one less than before: 53");

ok($row = $table->get_row(5));

is($row->cell_count, 2, "expected cell count: 2");

ok($row->clear_cell(1), "clear cell by index");

is($row->cell_count, 1, "expected cell count: 1");

ok($table->clear_row(5));

is($table->row_count, 52, "okay table row count one less than before");

is($table->header_count, 2, "header count: 2");

ok($table->clear_last_header, "clear last header");

is($table->header_count, 1, "header count: 1");

ok($table->clear_first_header, "clear first header");

is($table->header_count, 0, "header count: 0");

ok($tc->clear_first_table, "okay drop first table");

is($tc->table_count, 16, "one less table: 16");

ok($tc->clear_last_table, "drop last table");

is($tc->table_count, 15, "one less table: 15");

ok($tc->clear_table(5), "drop table by index 5");

is($tc->table_count, 14, "one less table: 14");

ok($table = $tc->get_first_table);

is($table->header_count, 2, "okay header count: 1");

is($table->row_count, 54, "okay row count");

is($table->get_first_row->cell_count, 2, "okay row cell count ~ 2");

ok($table->clear_column('Description'));

is($table->header_count, 1, "okay header count: 1");

is($table->get_first_row->cell_count, 1, "okay row cell count - 1");

ok( $tc->clear_table(0) );

is( $tc->table_count, 13, "one less table: 13");

ok($table = $tc->get_first_table);

is($table->header_count, 2, "okay header count: 1");

is($table->row_count, 8, "okay row count");

is($table->get_first_row->cell_count, 2, "okay first row cell count: 2");

is($table->get_last_row->cell_count, 2, "okay last row cell count: 2");

ok($table->clear_column('Description'), "clear column Description");

is($table->header_count, 1, "okay header count: 1");

is($table->get_first_row->cell_count, 1, "okay row cell count");

is($table->get_last_row->cell_count, 1, "okay row cell count: 1");

done_testing();

1;

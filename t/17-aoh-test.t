use strict;
use warnings;

use HTML::TableContent;

use Test::More;

my $aoh = [
    {
     'Name' => 'Rich',
     'Telephone' => '123456',
     'Postcode' => 'OX16 422',
    },
    {
     'Name' => 'Sam',
     'Telephone' => '1243543',
     'Postcode' => 'OX76 55R',
    },
    {
     'Name' => 'Frank',
     'Telephone' => '9553234',
     'Postcode' => 'OX14 R4E',
    }
];

my $tc = HTML::TableContent->new();

my $options = {
    aoh   => $aoh,
    order => ['Name', 'Telephone', 'Postcode'],
    table => {
        id => 'table-aoa',
    },
    header => {
        class => 'headers',
    },
    row => {
        class => 'rows',
    },
    cell => {
        class => 'cells',
    },
    rows => [
        {
            id    => 'first',
            cells => [
                {
                    id => 'one',
                },
                {
                    id => 'two',
                },
                {
                    id => 'three',
                }
            ]
        },
        {
            id => 'second',
        },
        {
            id => 'third',
        }
    ],
    headers => [
        {
            id => 'first-header',
        },
        {
            id => 'second-header',
        },
        {
            id => 'third-header',
        }
    ],
};

ok(my $table = $tc->create_table($options));

is_deeply($table->aoh, $aoh, "aoh is the same as passed in");

is($table->row_count, 3, "expected row count 3");

is($table->header_count, 3, "expected header count 3");

is($table->id, 'table-aoa', "table id: table-aoa");

is($table->get_first_header->text, 'Name', "expected header text: Name");

is($table->get_first_header->id, 'first-header', "expected header id: first-header");

is($table->get_first_header->cell_count, 3, "expected column cell count: 3");

is($table->get_first_header->class, 'headers', "expected header class: headers");

is($table->get_header(1)->text, 'Telephone', "expected header text: Telephone");

is($table->get_header(1)->id, 'second-header', "expected header id: second-header");

is($table->get_header(1)->cell_count, 3, "expected column cell count: 3");

is($table->get_header(1)->class, 'headers', "expected header class: headers");

is($table->get_last_header->text, 'Postcode', "expected header text: Postcode");

is($table->get_last_header->id, 'third-header', "expected header id: first-header");

is($table->get_last_header->cell_count, 3, "expected column cell count: 3");

is($table->get_last_header->class, 'headers', "expected header class: headers");

ok(my $row = $table->get_first_row, "get first row");

is($row->id, 'first', "expected header id: first");

is($row->cell_count, 3, "expected column cell count: 3");

is($row->class, 'rows', "expected header class: rows");

is($row->get_first_cell->text, 'Rich', "expected cell text: Rich");

is($row->get_first_cell->id, 'one', "expected cell id: one");

is($row->get_first_cell->header->text, 'Name', "expected cell header: Name");

is($row->get_first_cell->class, 'cells', "expected cell class: cells");

is($row->get_cell(1)->text, '123456', "expected header text: 123456");

is($row->get_cell(1)->id, 'two', "expected header id: two");

is($row->get_cell(1)->header->text, 'Telephone', "expected column name: Telephone");

is($row->get_cell(1)->class, 'cells', "expected header class: cells");

is($row->get_last_cell->text, 'OX16 422', "expected header text: OX16 422");

is($row->get_last_cell->id, 'three', "expected header id: three");

is($row->get_last_cell->header->text, 'Postcode', "expected header: Postcode");

is($row->get_last_cell->class, 'cells', "expected header class: cells");

ok(my $basic = $tc->create_table({ aoh => $aoh, order => ['Name', 'Telephone', 'Postcode'] }));

is_deeply($basic->aoh, $aoh, "aoa is the same as passed in");

is($basic->row_count, 3, "expected row count 3");

is($basic->header_count, 3, "expected header count 3");

is($basic->get_first_header->text, 'Name', "expected header text: Name");

is($basic->get_first_header->cell_count, 3, "expected column cell count: 3");

is($basic->get_header(1)->text, 'Telephone', "expected header text: Telephone");

is($basic->get_header(1)->cell_count, 3, "expected column cell count: 3");

is($basic->get_last_header->text, 'Postcode', "expected header text: Postcode");

is($basic->get_last_header->cell_count, 3, "expected column cell count: 3");

ok(my $basic_row = $basic->get_first_row, "get first row");

is($basic_row->cell_count, 3, "expected column cell count: 3");

is($basic_row->get_first_cell->text, 'Rich', "expected cell text: Rich");

is($basic_row->get_first_cell->header->text, 'Name', "expected cell header: Name");

is($basic_row->get_cell(1)->text, '123456', "expected header text: 123456");

is($basic_row->get_cell(1)->header->text, 'Telephone', "expected column name: Telephone");

is($basic_row->get_last_cell->text, 'OX16 422', "expected header text: OX16 422");

is($basic_row->get_last_cell->header->text, 'Postcode', "expected header: Postcode");

done_testing();

1;

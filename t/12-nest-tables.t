use strict;
use warnings;
use Test::More;
use Carp;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "nested column table" => sub {
    plan tests => 36;
    run_tests({
        file => 't/html/nest/one-table-cell-table.html',
        table_count => 1,
        header_count => 2,
        row_count => 2,
        has_nested => 1,
        nested_table_count => 2,
        nested_table_column => 1,
        nested_column_header => { 'facts' =>  1 },
        nested_table_header_count => 0,
        first_cell_text => 'Hello',
        second_row_cell_count => 2,
        row_nested_cell => 1,
        row_nested_cell_text => '你好',
    });
};

=head1 comment out tests

subtest "two tables nested" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/two-tables.html',
        expected_table_count => 1
        has_nested => 1,
        expected_nested_table_count => 2,
    });
};

subtest "three tables nested" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/three-tables.html',
        expected_table_count => 1,
        has_nested => 1,
        expected_nested_table_count => 3,
    });
};

subtest "three tables nested no headers" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/three-tables-no-headers.html',
        expected_table_count => 1,

        has_nested => 1,
        expected_nested_table_count => 3,
    });
};

subtest "three tables nested one header" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/three-tables-one-header.html',
        expected_table_count => 1,
        has_nested => 1,
        expected_nested_table_count => 3,
    });
};

subtest "three tables nested empty row" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/three-tables-empty-rows.html',
        expected_table_count => 1, 
        has_nested => 1,
        expected_nested_table_count => 3,
    });
};

subtest "three tables nested with some empty cells" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/nest/three-tables-empty-cells.html',
        expected_table_count => 1, 
        has_nested => 1,
        expected_nested_table_count => 3,
    });
};

=cut

done_testing();

sub open_file {
    my $file = shift;

    open ( my $fh, '<', $file ) or croak "could not open html: $file";
    my $html = do { local $/; <$fh> };
    close $fh;

    return $html;
}

sub run_tests {
    my $args = shift;

    my $file = $args->{file};
    
    my @loops = qw/parse parse_file/;

    foreach my $loop ( @loops ) {
        my $t = HTML::TableContent->new();
        if ( $loop eq 'parse' ) {
            my $html = open_file($file);
            ok($t->parse($html));
        }
        else {
            ok($t->parse_file($file));
        }
        
        is($t->table_count, $args->{table_count}, "correct table count $args->{table_count}");

        ok(my $table = $t->get_first_table);

        is($table->header_count, $args->{header_count}, "correct table header count $args->{header_count}");

        is($table->row_count, $args->{row_count}, "correct row count: $args->{row_count}");

        is($table->has_nested, $args->{has_nested}, "table has nested tables: $args->{has_nested}");

        is($table->count_nested, $args->{nested_table_count}, "correct nested table count: $args->{nested_table_count}");

        is($table->has_nested_table_column, $args->{nested_table_column}, "has nested table column");

        is_deeply($table->nested_column_headers, $args->{nested_column_header}, "correct nested column headers");

        ok(my $nest = $table->get_col((keys %{ $args->{nested_column_header}})[0]));
        
        ok( my $col_table = $nest->[0]->get_first_nested);

        is($col_table->header_count, $args->{nested_table_header_count}, "correct header count: $args->{nested_table_header_count}");

        is($col_table->get_first_row->get_first_cell->text, $args->{first_cell_text}, "correct cell value: $args->{first_cell_text}");

        ok(my $row = $table->get_row(1));

        is($row->cell_count, $args->{second_row_cell_count}, "expected row count: $args->{second_row_cell_count}");

        is($row->has_nested, $args->{row_nested_cell}, "nested cell: $args->{row_nested_cell}");

        ok(my $tcell = $row->get_cell(1));

        is($tcell->get_first_nested->get_first_row->get_first_cell->text, $args->{row_nested_cell_text}, "nested text: $args->{row_nested_cell_text}");
     }
}

1;

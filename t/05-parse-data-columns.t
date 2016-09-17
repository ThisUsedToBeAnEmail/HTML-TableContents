use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "simple-one-html-column" => sub {
    plan tests => 19;
    my $html = open_file('t/html/simple-one-html-column.html');
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_header_count => 1,
        table_class => 'something',
        table_id => 'test-id',
        table_row_count => 1,
        row => 0,
        row_cell_count => 1,
        row_class => 'echo',
        row_id => 'test-row-id',
        cell => 0,
        cell_header_class => 'header',
        cell_header_text => 'this',
        cell_header_data_0 => 'this',
        cell_class => 'ping',
        cell_id => 'test-cell-id',
        cell_text => 'thing just because they can',
        cell_data_0 => 'thing',
        cell_data_1 => 'just because they can'
    });  
};

subtest "broken-html-two-columns" => sub {
    my $html = open_file('t/html/page-two-tables-columns.html');
    run_tests({
        html => $html,
        count => 2,
        table => 0,
        table_header_count => 2,
        table_class => 'two-columns',
        table_id => 'table-1',
        table_row_count => 2,
        row => 0,
        row_cell_count => 2,
        row_class => 'two-column-odd',
        row_id => 'row-1',
        cell => 1,
        cell_header_class => 'savings', 
        cell_header_text => 'Savings',
        cell_header_data_0 => 'Savings',
        cell_class => 'price',
        cell_text => '$100 usd',
        cell_data_0 => '$100',
        cell_data_1 => 'usd'
    }); 
    run_tests({
        file => 't/html/page-two-tables-columns.html',
        count => 2,
        table => 1,
        table_header_count => 2,
        table_class => 'two-columns',
        table_id => 'table-2',
        table_row_count => 2,
        row => 1,
        row_cell_count => 2,
        row_class => 'two-column-even',
        row_id => 'row-2',
        cell => 0,
        cell_header_class => 'month',
        cell_header_text => 'Month',
        cell_header_data_0 => 'Month',
        cell_id => 'month-02',
        cell_text => 'Febuary 02',
        cell_data_0 => 'Febuary',
        cell_data_1 => '02'
    });
};

done_testing();

sub open_file {
    my $file = shift;

    open ( my $fh, '<', $file ) or croak "could not open file: $file"; 
    my $html = do { local $/; <$fh> };
    close $fh;
    
    return $html;
}

sub run_tests {
    my $args = shift;

    my $t = HTML::TableContent->new();
    
    if (my $html = $args->{html}) {
        ok($t->parse($html), "parse html into HTML::TableContent");
    }

    if ( my $file = $args->{file}) {
        ok($t->parse_file($file), "parse html into HTML::TableContent");
    }

    if ( my $count = $args->{count} ) {
        is($t->table_count, $count, "correct table count: $count");
    }
    
    ok(my $table = $t->tables->[$args->{table}], "found table index: $args->{table}");
 
    if ( my $row_count = $args->{table_row_count} ) {
        is($table->row_count, $row_count, "correct row count: $row_count");
    }

    if ( my $header_count = $args->{table_header_count} ) { 
        is($table->header_count, $header_count, "expected header count: $header_count");
    }

    if ( my $table_class = $args->{table_class} ) {
        is($table->class, $table_class, "table class: $table_class");
    }

    if ( my $table_id = $args->{table_id} ) {
        is($table->id, $table_id, "table class: $table_id");
    }

    if ( defined $args->{row} ) {
        ok(my $row = $table->rows->[$args->{row}], "found row index: $args->{row}");

        if ( my $cell_count = $args->{row_cell_count} ) {
            is($row->cell_count, $cell_count, "expected cell count: $cell_count");
        }

        if ( my $row_class = $args->{row_class} ) {
            is($row->class, $row_class, "row class: $row_class");
         }

        if ( my $row_id = $args->{row_id} ) {
            is($row->id, $row_id, "row id: $row_id"); 
        }

        if ( defined $args->{cell} ) {
            ok(my $cell = $row->cells->[$args->{cell}], "found cell index: $args->{cell}");
            
            if ( defined $table->headers ) {
                my $header = $table->headers->[$args->{cell}];
                if ( my $cell_header = $args->{cell_header} ) {
                    is($header->text, $cell_header, "expected cell_header: $cell_header");
                }
                
                if ( my $cell_header_data_0 = $args->{cell_header_data_0} ) {
                    is($header->data->[0], $cell_header_data_0, "expected cell_header: $cell_header_data_0");
                }

                if ( my $cell_header_data_1 = $args->{cell_header_data_1} ) {
                    is($header->data->[1], $cell_header_data_1, "expected cell_header: $cell_header_data_1");
                }


                if ( my $header_class = $args->{cell_header_class} ) {
                    is( $header->class, $header_class, "header class: $header_class");   
                }
            }
            
            if ( my $cell_class = $args->{cell_class} ) {
                is($cell->class, $cell_class, "cell class: $cell_class");
            }
            
            if ( my $cell_id = $args->{cell_id} ) {
                is($cell->id, $cell_id, "cell id: $cell_id");
            }
            
            if ( my $cell_text = $args->{cell_text} ) {
                is($cell->text, $cell_text, "cell text: $cell_text");
            }

            if ( my $cell_data_0 = $args->{cell_data_0} ) {
                is($cell->data->[0], $cell_data_0, "cell data: $cell_data_0");
            }
            
            if ( my $cell_data_1 = $args->{cell_data_1} ) {
                is($cell->data->[1], $cell_data_1, "cell data: $cell_data_1");
            }
        }
    }
}

1;

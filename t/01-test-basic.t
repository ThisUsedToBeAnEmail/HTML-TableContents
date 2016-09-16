use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "basic_single_column_table" => sub {
    plan tests => 14;
    my $html = open_file('t/html/simple-one-column-table.html');
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'something',
        table_id => 'test-id',
        row => 0,
        row_class => 'echo',
        row_id => 'test-row-id',
        cell => 0,
        cell_header_class => 'header',
        cell_header => 'this',
        cell_class => 'ping',
        cell_id => 'test-cell-id',
        cell_text => 'thing'
    });  
};

subtest "basic_two_column_table" => sub {
    plan tests => 26;
    my $html = open_file('t/html/simple-two-column-table.html');
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'two-columns',
        table_id => 'two-id',
        row => 0,
        row_class => 'two-column-odd',
        row_id => 'row-1',
        cell => 1,
        cell_header_class => 'savings', 
        cell_header => 'Savings',
        cell_class => 'price',
        cell_text => '$100'
    }); 
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'two-columns',
        table_id => 'two-id',
        row => 1,
        row_class => 'two-column-even',
        row_id => 'row-2',
        cell => 0,
        cell_header_class => 'month',
        cell_header => 'Month',
        cell_id => 'month-02',
        cell_text => 'Febuary'
    });
};

subtest "simple_three_column_table" => sub {
    plan tests => 39;
    my $html = open_file('t/html/simple-three-column-table.html');
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'three-columns',
        table_id => 'three-id',
        row => 0,
        row_class => 'three-column-odd',
        row_id => 'row-1',
        cell => 1,
        cell_header_class => 'bold',
        cell_header => 'Last Name',
        cell_class => 'second-name ital',
        cell_text => 'Janet'
    }); 
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'three-columns',
        table_id => 'three-id',
        row => 1,
        row_class => 'three-column-even',
        row_id => 'row-2',
        cell => 0,
        cell_header_class => 'bold',
        cell_header => 'First Name',
        cell_class => 'first-name bold',
        cell_text => 'Raymond'
    });
    run_tests({
        html => $html,
        count => 1,
        table => 0,
        table_class => 'three-columns',
        table_id => 'three-id',
        row => 2,
        row_class => 'three-column-odd',
        row_id => 'row-3',
        cell => 2,
        cell_header_class => 'bold',
        cell_header => 'Email',
        cell_class => 'email',
        cell_text => 'lukas@emails.com'
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

    my $html = $args->{html};

    my $t = HTML::TableContent->new();
    $t->debug_on(1);
    ok($t->parse($html), "parse html into HTML::TableContent");

    ok(my $table = $t->tables->[$args->{table}], "found table index: $args->{table}");
    if ( my $count = $args->{count} ) {
        is($t->table_count, $count, "correct table count: $count");
    }

    if ( my $table_class = $args->{table_class} ) {
        is($table->class, $table_class, "table class: $table_class");
    }

    if ( my $table_id = $args->{table_id} ) {
        is($table->id, $table_id, "table class: $table_id");
    }

    if ( defined $args->{row} ) {
        ok(my $row = $table->rows->[$args->{row}], "found row index: $args->{row}");

        if ( my $row_class = $args->{row_class} ) {
            is($row->class, $row_class, "row class: $row_class");
         }

        if ( my $row_id = $args->{row_id} ) {
            is($row->id, $row_id, "row id: $row_id"); 
        }

        if ( defined $args->{cell} ) {
            ok(my $cell = $row->cells->[$args->{cell}], "found cell index: $args->{cell}");
            if ( my $cell_header = $args->{cell_header} ) {
                my $header = $table->headers->[$args->{cell}];
                is($header->text, $cell_header, "expected cell_header: $cell_header");
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
        }
    }
}

1;

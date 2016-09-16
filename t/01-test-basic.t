use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "basic_single_column_table" => sub {
    plan tests => 11;
    my $html = open_file('t/html/table.html');
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
        cell_class => 'ping',
        cell_id => 'test-cell-id',
        cell_text => 'thing'
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
    $t->parse($html);

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

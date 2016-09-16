use strict;
use warnings;
use Test::More;
use Data::Dumper;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "basic_single_column_table" => sub {
    my $html = open_file('t/html/table.html');
    run_tests({
        html => $html,
        count => 1,
        table_class => 'something'
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

    my $html = delete $args->{html};
    my $t = HTML::TableContent->new();
    $t->parse($html);

    if ( my $count = $args->{count} ) {
        is($t->table_count, $count, "correct table count: $count");
    }

    if ( my $table_class = $args->{table_class} ) {
        is($t->tables->[0]->class, $table_class, "table class: $table_class");
    }
}

1;

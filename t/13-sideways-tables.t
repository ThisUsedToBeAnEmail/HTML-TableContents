use strict;
use warnings;
use Test::More;
use Carp;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "one table sideways" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/one-table.html',
        expected_table_count => 1,
    });
};

subtest "two tables sideways" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/two-tables.html',
        expected_table_count => 2
    });
};

subtest "three tables sideways" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/three-tables.html',
        expected_table_count => 3,
    });
};

subtest "three tables sideways one header" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/three-tables-one-header.html',
        expected_table_count => 3,
    });
};

subtest "three tables sideways empty row" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/three-tables-empty-rows.html',
        expected_table_count => 3,
    });
};

subtest "three tables sideways with some empty cells" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/sideway/three-tables-empty-cells.html',
        expected_table_count => 3, 
    });
};

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
            use Data::Dumper; 
            ok($t->parse($html));
        }
        else {
            ok($t->parse_file($file));
        }
        
        is($t->table_count, $args->{expected_table_count}, "correct table count $args->{expected_table_count}");

        is($t->has_sideways_tables, $args->{has_sideways}, "we have sideways tables");

        is($t->sideways_table_count, $args->{table_sideways_count}, "correct sideways table count");
     }
}

1;

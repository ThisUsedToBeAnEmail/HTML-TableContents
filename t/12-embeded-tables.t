use strict;
use warnings;
use Test::More;
use Carp;

BEGIN {
    use_ok("HTML::TableContent");
}

# All templates are a single table 3 x 3 - but with subtle differences.
subtest "one table embedded" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/one-table.html',
        expected_table_count => 1,
        has_embedded => 1,
        expected_embedded_table_count => 1
    });
};

subtest "two tables embedded" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/two-tables.html',
        expected_table_count => 1
        has_embedded => 1,
        expected_embedded_table_count => 2,
    });
};

subtest "three tables embedded" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/three-tables.html',
        expected_table_count => 1,
        has_embedded => 1,
        expected_embedded_table_count => 3,
    });
};

subtest "three tables embedded no headers" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/three-tables-no-headers.html',
        expected_table_count => 1,

        has_embedded => 1,
        expected_embedded_table_count => 3,
    });
};

subtest "three tables embedded one header" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/three-tables-one-header.html',
        expected_table_count => 1,
        has_embedded => 1,
        expected_embedded_table_count => 3,
    });
};

subtest "three tables embedded empty row" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/three-tables-empty-rows.html',
        expected_table_count => 1, 
        has_embedded => 1,
        expected_embedded_table_count => 3,
    });
};

subtest "three tables embedded with some empty cells" => sub {
    plan tests => 18;
    run_tests({
        file => 't/html/embed/three-tables-empty-cells.html',
        expected_table_count => 1, 
        has_embedded => 1,
        expected_embedded_table_count => 3,
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

        is($t->has_embedded_tables, $args->{has_embedded}, "we have embedded tables");

        is($t->embedded_table_count, $args->{table_embedded_count}, "correct embedded table count");
     }
}

1;

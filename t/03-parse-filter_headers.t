use strict;
use warnings;
use Test::More;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "basic_two_column_table" => sub {
    plan tests => 20;
    my $html = open_file('t/html/simple-two-column-table.html');
    run_tests({
        html => $html,
        table_count => 1,
        header_spec => {
            'Savings' => 1,
            'Month' => 1
        },
        header_count => 2,
        filter_headers => ['Savings', 'Month'],
        after_header_count => 2,
        after_header_spec => {
            'Savings' => 1,
            'Month' => 1,
        },
        after_table_count => 1,
    });
    run_tests({
        html => $html,
        table_count => 1,
        header_spec => {
            'Savings' => 1,
            'Month' => 1
        },
        header_count => 2,
        filter_headers => ['Savings'],
        after_header_count => 1,
        after_header_spec => {
            'Savings' => 1
        },
        after_table_count => 1,
    });
};

subtest "simple_three_column_table" => sub {
    plan tests => 30;
    my $html = open_file('t/html/simple-three-column-table.html');
    run_tests({
        html => $html,
        table_count => 1,
        header_spec => {
            'Last Name' => 1,
            'First Name' => 1,
            'Email' => 1
        },
        header_count => 3,
        filter_headers => ['First Name', 'Last Name', 'Email'],
        after_header_count => 3,
        after_header_spec => {
            'First Name' => 1,
            'Last Name' => 1,
            'Email' => 1,
        },
        after_table_count => 1,
    });
    run_tests({
        html => $html,
        table_count => 1,
         header_spec => {
            'Last Name' => 1,
            'First Name' => 1,
            'Email' => 1
        },
        header_count => 3,
        filter_headers => ['First Name', 'Email'],
        after_header_count => 2,
        after_header_spec => {
            'First Name' => 1,
            'Email' => 1,
        },
        after_table_count => 1,
    });
    run_tests({
        html => $html,
        table_count => 1,
        header_spec => {
            'Last Name' => 1,
            'First Name' => 1,
            'Email' => 1
        },
        header_count => 3,
        first_table_header_count => 3,
        filter_headers => ['Email'],
        after_header_count => 1,
        after_header_spec => {
            'Email' => 1,
        },
        after_table_count => 1,
    });
};

subtest "page_two_tables" => sub {
    plan tests => 20;
    my $html = open_file('t/html/page-two-tables.html');
    run_tests({
        html => $html,
        table_count => 2,
        header_spec => {
            'Expenditure' => 1,
            'Savings' => 1,
            'Month' => 2
        },
        filter_headers => [qw/Expenditure Month Savings/],
        header_count => 2,
        after_header_count => 2,
        after_header_spec => {
            'Expenditure' => 1,
            'Month' => 2,
            'Savings' => 1,
        },
        after_table_count => 2,
    });
    run_tests({
        html => $html,
        table_count => 2,
        header_spec => {
            'Expenditure' => 1,
            'Savings' => 1,
            'Month' => 2
        },
        filter_headers => [qw/Expenditure Savings/],
        header_count => 2,
        after_header_count => 1,
        after_header_spec => {
            'Expenditure' => 1,
            'Savings' => 1,
        },       
        after_table_count => 2,
    });
};

subtest "page_three_tables" => sub {
    plan tests => 30;
    my $html = open_file('t/html/page-three-tables.html');
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 3,
          'Last Name' => 3,
          'Email' => 3
        },
        header_count => 3,
        filter_headers => ['First Name', 'Last Name', 'Email'],
        after_header_count => 3,
        after_header_spec => {
            'First Name' => 3,
            'Last Name' => 3,
            'Email' => 3,
        },
        after_table_count => 3,
    });
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 3,
          'Last Name' => 3,
          'Email' => 3
        },      
        filter_headers => ['First Name', 'Last Name'],
        header_count => 3,
        after_header_count => 2,
        after_header_spec => {
            'First Name' => 3,
            'Last Name' => 3,
        },
        after_table_count => 3,
    });
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 3,
          'Last Name' => 3,
          'Email' => 3
        },
        filter_headers => ['First Name'],
        header_count => 3,
        after_header_count => 1,
        after_header_spec => {
            'First Name' => 3
        },
        after_table_count => 3,
    });
};

subtest "page_three_tables" => sub {
    plan tests => 30;
    my $html = open_file('t/html/page-random-tables.html');
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 1,
          'Last Name' => 1,
          'Email' => 1,
          'Year' => 2,
          'Month' => 2,
          'Savings' => 1,
          'Expence' => 1,
        },
        filter_headers => ['First Name', 'Last Name', 'Email'],
        header_count => 3,
        after_header_count => 3,
        after_header_spec => {
            'First Name' => 1,
            'Last Name' => 1,
            'Email' => 1,
        }, 
        after_table_count => 1,
    });
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 1,
          'Last Name' => 1,
          'Email' => 1,
          'Year' => 2,
          'Month' => 2,
          'Savings' => 1,
          'Expence' => 1,
        },
        filter_headers => ['First Name'],
        header_count => 3,
        after_header_count => 1,
        after_header_spec => {
            'First Name' => 1
        },      
        after_table_count => 1,
    });
    run_tests({
        html => $html,
        table_count => 3,
        header_spec => {
          'First Name' => 1,
          'Last Name' => 1,
          'Email' => 1,
          'Year' => 2,
          'Month' => 2,
          'Savings' => 1,
          'Expence' => 1,
        },
        filter_headers => [qw/Year Month Savings/],
        header_count => 3,
        after_header_count => 3,
        after_header_spec => {
            'Year' => 2,
            'Month' => 2,
            'Savings' => 1
        },
        after_table_count => 2,
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

    my $t = HTML::TableContent->new();
    
    ok($t->parse($args->{html}), "parse html into HTML::TableContent");

    is($t->table_count, $args->{table_count}, "expected table count: $args->{table_count}");
    
    ok(my $header_spec = $t->headers_spec);
    
    is_deeply($header_spec, $args->{header_spec}, "expected header spec");

    is($t->tables->[0]->header_count, $args->{header_count}, "header count: $args->{header_count}");

    my @headers = $args->{filter_headers};

    ok($t->filter_tables(headers => @headers));    

    is($t->tables->[0]->header_count, $args->{after_header_count}, "expected after header count $args->{after_header_count}");

    ok($header_spec = $t->headers_spec);

    is_deeply($header_spec, $args->{after_header_spec}, "expected after header spec");
    
    is($t->table_count, $args->{after_table_count}, "expected after table count: $args->{after_table_count}");
}

1;

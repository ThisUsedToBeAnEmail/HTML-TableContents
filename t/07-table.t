use strict;
use warnings;
use Test::More;
use Carp qw/croak/;

BEGIN {
    use_ok("HTML::TableContent");
}

subtest "basic_two_column_table" => sub {
    plan tests => 9;
    my $html = open_file('t/html/page-two-tables.html');
    run_tests({
        html => $html,
        get_first_table => 1,
        row_count => 2,
        header_count => 2,
        headers_spec => {
            'Month' => 1,
            'Savings' => 1,
        },
        header_exists => qw/Savings/,
        raw => {
            'class' => 'two-columns',
            'rows' => [
                        {
                          'class' => 'two-column-odd',
                          'id' => 'row-1',
                          'cells' => [
                                       {
                                         'id' => 'month-01',
                                         'data' => [
                                                     'January'
                                                   ],
                                         'text' => 'January'
                                       },
                                       {
                                         'text' => '$100',
                                         'data' => [
                                                     '$100'
                                                   ],
                                         'class' => 'price'
                                       }
                                     ]
                        },
                        {
                          'id' => 'row-2',
                          'cells' => [
                                       {
                                         'id' => 'month-02',
                                         'text' => 'Febuary',
                                         'data' => [
                                                     'Febuary'
                                                   ]
                                       },
                                       {
                                         'text' => '$100',
                                         'data' => [
                                                     '$100'
                                                   ],
                                         'class' => 'price'
                                       }
                                     ],
                          'class' => 'two-column-even'
                        }
                      ],
            'id' => 'table-1',
            'headers' => [
                           {
                             'class' => 'month',
                             'text' => 'Month',
                             'data' => [
                                         'Month'
                                       ]
                           },
                           {
                             'text' => 'Savings',
                             'data' => [
                                         'Savings'
                                       ],
                             'class' => 'savings'
                           }
                         ]
          },
        get_first_header => 1,
        get_first_row => 1,
    });
};

subtest "basic_two_column_table_file" => sub {
    plan tests => 9;
    my $file = 't/html/page-two-tables.html';
    run_tests({
        file => $file,
        get_first_table => 1,
        row_count => 2,
        header_count => 2,
        headers_spec => {
            'Month' => 1,
            'Savings' => 1,
        },
        header_exists => qw/Savings/,
        raw => {
            'class' => 'two-columns',
            'rows' => [
                        {
                          'class' => 'two-column-odd',
                          'id' => 'row-1',
                          'cells' => [
                                       {
                                         'id' => 'month-01',
                                         'data' => [
                                                     'January'
                                                   ],
                                         'text' => 'January'
                                       },
                                       {
                                         'text' => '$100',
                                         'data' => [
                                                     '$100'
                                                   ],
                                         'class' => 'price'
                                       }
                                     ]
                        },
                        {
                          'id' => 'row-2',
                          'cells' => [
                                       {
                                         'id' => 'month-02',
                                         'text' => 'Febuary',
                                         'data' => [
                                                     'Febuary'
                                                   ]
                                       },
                                       {
                                         'text' => '$100',
                                         'data' => [
                                                     '$100'
                                                   ],
                                         'class' => 'price'
                                       }
                                     ],
                          'class' => 'two-column-even'
                        }
                      ],
            'id' => 'table-1',
            'headers' => [
                           {
                             'class' => 'month',
                             'text' => 'Month',
                             'data' => [
                                         'Month'
                                       ]
                           },
                           {
                             'text' => 'Savings',
                             'data' => [
                                         'Savings'
                                       ],
                             'class' => 'savings'
                           }
                         ]
          },
        get_first_header => 1,
        get_first_row => 1,

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
    
    if (my $html = $args->{html} ) {    
        ok($t->parse($args->{html}), "parse html into HTML::TableContent");
    } else {
        ok($t->parse_file($args->{file}, "parse file into HTML::TableContent"));
    }

    ok(my $table = $t->get_first_table, "get first table");
        
    is($table->header_count, $args->{header_count}, "expected headers count");

    is($table->row_count, $args->{row_count}, "expected row count");

    is_deeply( $table->headers_spec, $args->{headers_spec}, "expected header spec" );

    is($table->header_exists($args->{header_exists}), 1, "okay header exists: $args->{header_exists}" );

    is_deeply($table->raw, $args->{raw}, "expected raw structure");
       
    ok( $table->get_first_row, "okay get first row" );

    ok( $table->get_first_header, "okay get first header" );
}

1;

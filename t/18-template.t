use strict;
use warnings;
use Test::More;
use Carp qw/croak/;

BEGIN {
    use_ok("t::Templates::JustHeaders");
    use_ok("t::Templates::JustHeadersArray");
    use_ok("t::Templates::JustHeadersPassData");
    use_ok("t::Templates::JustHeadersText");
    use_ok("t::Templates::AllRows");
    use_ok("t::Templates::OddEvenRows");
    use_ok("t::Templates::IndexRows");
    use_ok("t::Templates::IndexFlagRows");
}

subtest "just_headers" => sub  {
    plan tests => 33;
    run_tests({
        class => 't::Templates::JustHeaders',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "just_headers_data_is_aoa" => sub  {
    plan tests => 33;
    run_tests({
        class => 't::Templates::JustHeadersArray',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "just_headers_pass_data_aoh" => sub  {
    plan tests => 33;
    run_tests({
        class => 't::Templates::JustHeadersPassData',
        data => [
           {
                id => 1,
                name => 'rob',
                address => 'somewhere',
            },
            {
                id => 2,
                name => 'sam',
                address => 'somewhere else',
            },
            {
                id => 3,
                name => 'frank',
                address => 'out',
            },
        ],
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "just_headers_pass_data_aoa" => sub  {
    plan tests => 33;
    run_tests({
        class => 't::Templates::JustHeadersPassData',
        data => [
            [qw/id name address/],
            [ 1, 'rob', 'somewhere'],
            [ 2, 'sam', 'somewhere else'],
            [ 3, 'frank', 'out'],        
        ],
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "just_headers_text" => sub {
    plan tests => 33;
    run_tests({
        class => 't::Templates::JustHeadersText',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'User Id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'User Name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'User Address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'User Id',
        },
        first_row => {
            cell_count => 3,
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">User Id</th><th class="okay">User Name</th><th class="what">User Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "all_rows" => sub  {
    plan tests => 34;
    run_tests({
        class => 't::Templates::AllRows',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
            class => 'all_rows',
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr class="all_rows"><td>1</td><td>rob</td><td>somewhere</td></tr><tr class="all_rows"><td>2</td><td>sam</td><td>somewhere else</td></tr><tr class="all_rows"><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "odd_even_rows" => sub  {
    plan tests => 34;
    run_tests({
        class => 't::Templates::OddEvenRows',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
            class => 'odd',
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr class="odd"><td>1</td><td>rob</td><td>somewhere</td></tr><tr class="even"><td>2</td><td>sam</td><td>somewhere else</td></tr><tr class="odd"><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "by_row_index" => sub  {
    plan tests => 35;
    run_tests({
        class => 't::Templates::IndexRows',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
            class => 'first',
            id => 'first-row',
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr class="first" id="first-row"><td>1</td><td>rob</td><td>somewhere</td></tr><tr class="second" id="second-row"><td>2</td><td>sam</td><td>somewhere else</td></tr><tr class="third" id="third-row"><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};

subtest "by_row_flag_index" => sub  {
    plan tests => 35;
    run_tests({
        class => 't::Templates::IndexFlagRows',
        caption => {
            title => {
                template_attr => 'title',
                class => 'some-class',
                id => 'caption-id',
                text => 'table caption',
            }
        },
        headers => {
            id => {
                template_attr => 'id',
                class => 'some-class',
                id => 'something-id',
                text => 'id',
            },
            name => {
                template_attr => 'name',
                class => 'okay',
                text => 'name',
            },
            address => {
                template_attr => 'address',
                class => 'what',
                text => 'address',
            }
        },
        table => {
            row_count => 3,
            header_count => 3,
        },
        first_header => {
            template_attr => 'id',
            class => 'some-class',
            id => 'something-id',
            text => 'id',
        },
        first_row => {
            cell_count => 3,
            class => 'first',
            id => 'first-row',
        },
        fr_first_cell => {
            text => '1',
        },
        fr_last_cell => {
            text => 'somewhere',
        },
        render => '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr class="first" id="first-row"><td>1</td><td>rob</td><td>somewhere</td></tr><tr class="second" id="second-row"><td>2</td><td>sam</td><td>somewhere else</td></tr><tr class="third" id="third-row"><td>3</td><td>frank</td><td>out</td></tr></table>',
    });
};


done_testing();

sub run_tests {
    my $args = shift;

    my $class = $args->{class};

    my $template;
    if (my $data = $args->{data}) {
        use Data::Dumper;
        $template = $class->new({ data => $data });
    } else {
        $template = $class->new();
    }
    my $exp_caption = $args->{caption};

    my @cap_keys = keys %{ $exp_caption };
    my $attr = $cap_keys[0];
    ok(my $caption = $template->$attr);
    
    while ( my ( $action, $expected ) = each %{ $exp_caption->{$attr} } ) {
        is($caption->$action, $expected, "$action expected $expected");
    }

    my $exp_headers = $args->{headers};

    my @head_keys = keys %{ $exp_headers };

    foreach my $key (@head_keys) {
        ok(my $header = $template->$key, "okay $key");

        while ( my ( $action, $expected ) = each %{ $exp_headers->{$key} } ) {
            is($header->$action, $expected, "$key - $action expected $expected");
        }
    }

    ok(my $table = $template->table, "okay get table");
    my $exp_table = $args->{table};

    while ( my ( $action, $expected ) = each %{ $exp_table } ) {
        is($table->$action, $expected, "$action expected $expected");
     }

    ok(my $first_header = $table->get_first_header, "okay get first header");
    my $exp_first_header = $args->{first_header};
    while ( my ( $action, $expected ) = each %{ $exp_first_header } ) {
        is($first_header->$action, $expected, "first header - $action expected $expected");
    }

    ok(my $first_row = $table->get_first_row, "okay get first row");
    
    my $exp_first_row = $args->{first_row};
    while ( my ( $action, $expected ) = each %{ $exp_first_row } ) {
        is($first_row->$action, $expected, "first row - $action expected $expected");
    }

    ok(my $first_cell = $first_row->get_first_cell, "okay get first cell");

    my $exp_first_cell = $args->{fr_first_cell};
    while ( my ( $action, $expected ) = each %{ $exp_first_cell } ) {
        is($first_cell->$action, $expected, "first row first cell - $action expected $expected");
    }

    ok(my $last_cell = $first_row->get_last_cell, "get last cell");

    my $exp_last_cell = $args->{fr_last_cell};
    while ( my ( $action, $expected ) = each %{ $exp_last_cell } ) {
        is($last_cell->$action, $expected, "first row last cell - $action expected $expected");
    }

    is($template->render, $args->{render}, "$args->{render}");
}

1;

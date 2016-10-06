use strict;
use warnings;
use Test::More;
use Carp qw/croak/;

BEGIN {
   use_ok("t::Templates::JustHeaders");
}

subtest "just_headers" => sub  {
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
        }
    });
};

sub run_tests {
    my $args = shift;

    my $class = $args->{class};
    my $template = $class->new();
    
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
        ok(my $header = $template->$key);
    
        while ( my ( $action, $expected ) = each %{ $exp_caption->{$attr} } ) {
            is($caption->$action, $expected, "$action expected $expected");
        }
    }

    use Data::Dumper;
    warn Dumper $template->table;

    warn Dumper $template->render;
}

1;

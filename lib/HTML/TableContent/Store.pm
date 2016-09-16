package HTML::TableContent::Store;

use Moo;

has [ qw(current_table current_caption current_row current_header current_cell current_element) ] => (
    is => 'rw',
    lazy => 1,
    clearer => 1,
);

has options => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build_options {
    return {
        table => {
            class => 'Table',
            store => [qw/current_table/],
            push_action => '_push_table',
            clear => [qw/current_table current_row current_cell current_header current_element/],
        },
        th => {
            class => 'Table::Header',
            store => [qw/current_header current_element/],
            push_action => '_push_header',
            clear => [qw/current_row current_cell current_header current_element/],
        },
        tr => {
            class => 'Table::Row',
            store => [qw/current_row current_element/],
            push_action => '_push_row',
            clear => [qw/current_row current_cell current_header current_element/],
        }, 
        td => {
            class => 'Table::Cell',
            store => [qw/current_cell current_element/], 
            push_action => '_push_cell',
            clear => [qw/current_cell current_header current_element/],
        },
        caption => {
            class => 'Table::Caption',
            store => [qw/current_element/],
            push_action => '_push_caption',
            clear => [qw/current_element/]
        }
   }
}

__PACKAGE__->meta->make_immutable;

1;


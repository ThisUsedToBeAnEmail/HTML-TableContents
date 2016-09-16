package HTML::TableContent::Store;

use Moo;

has [ qw(tables) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

has [ qw(current_table current_row current_header current_cell current_element) ] => (
    is => 'rw',
    lazy => 1,
    clearer => 1,
);

has 'tags' => (
    is => 'ro',
    lazy => 1,
    builder => '_build_tags',
);

sub _build_tags {
    return {
        table => { 
            clear => [qw/current_table current_row current_cell current_header current_element/],
        },
        th => {
            clear => [qw/current_row current_cell current_header current_element/],
        },
        tr => {
            clear => [qw/current_row current_cell current_header current_element/],
        },
        td => { 
            clear => [qw/current_cell current_header current_element/],
        },
        caption => {
            clear => [qw/current_element/],
        },
   }
}

__PACKAGE__->meta->make_immutable;

1;


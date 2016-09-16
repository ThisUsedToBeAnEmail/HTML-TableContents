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
);

__PACKAGE__->meta->make_immutable;

1;


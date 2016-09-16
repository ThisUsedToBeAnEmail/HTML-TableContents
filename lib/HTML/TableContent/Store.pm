package HTML::TableContent::Store;

use Moo;

has [ qw(current_table current_row current_header current_cell current_element) ] => (
    is => 'rw',
    lazy => 1,
    clearer => 1,
);

has 'clear_tags' => (
    is => 'ro',
    lazy => 1,
    builder => '_build_clear_tags',
);

sub _build_clear_tags {
    return {
        table =>  
            [qw/current_table current_row current_cell current_header current_element/],
        th => 
            [qw/current_row current_cell current_header current_element/],
        tr => 
            [qw/current_row current_cell current_header current_element/],
        td =>  
            [qw/current_cell current_header current_element/],
        caption => 
            [qw/current_element/],
   }
}

__PACKAGE__->meta->make_immutable;

1;


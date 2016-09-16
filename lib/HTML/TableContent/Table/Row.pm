package HTML::TableContent::Table::Row;

use Moo;

has [ qw(cells) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

__PACKAGE__->meta->make_immutable;

1;


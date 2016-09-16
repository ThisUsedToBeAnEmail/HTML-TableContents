package HTML::TableContent::Table;

use Moo;

has [ qw(headers rows) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

__PACKAGE__->meta->make_immutable;

1;


package HTML::TableContent::Table;

use Moo;

has [ qw(headers rows) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

has 'caption' => (
    is => 'rw',
);

__PACKAGE__->meta->make_immutable;

1;


package HTML::TableContent::Table;

use Moo;
use Data::Dumper;

with 'HTML::TableContent::Role::Content';

has 'caption' => (
    is => 'rw',
);

has [ qw(headers rows) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

__PACKAGE__->meta->make_immutable;

1;


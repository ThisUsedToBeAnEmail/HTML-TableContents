package HTML::TableContent::Table;

use Moo;
use Data::Dumper;
use Hash::Objectify;

with 'HTML::TableContent::Role::Attributes';

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


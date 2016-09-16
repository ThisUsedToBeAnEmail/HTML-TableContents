package HTML::TableContent::Table::Row;

use Moo;

with 'HTML::TableContent::Role::Content';

has 'cells' => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

sub cell_count {
    return scalar @{ shift->cells };
}

__PACKAGE__->meta->make_immutable;

1;


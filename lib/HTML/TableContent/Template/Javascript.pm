package HTML::TableContent::Template::Javascript;

use Moo::Role;

has 'header_functions' => (
    is => 'ro',
    default => sub { [ ] },
);

sub render_header_js {
    return join "\n", @{ $_[0]->header_functions };
}

has 'table_functions' => (
    is => 'ro',
    default => sub { [ ] },
);

sub render_table_js {
    return join "\n", @{ $_[0]->table_functions };
}

1;

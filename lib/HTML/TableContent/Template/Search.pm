package HTML::TableContent::Template::Search;

use Moo::Role;
use HTML::TableContent::Element;

has search_columns => (
    is => 'rw',
    lazy => 1,
    default => sub { { } },
);

has [qw/search_text search_box_position/] => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_search_text {
    my $default_text = 'Search table for...';
    my $table_spec = $_[0]->table_options;
    return defined $table_spec->{search_text} ? $table_spec->{search_text} : $default_text;
}     

sub _build_search_box_position {
    my $table_spec = $_[0]->table_options;
    return defined $table_spec->{search_box_position} ? $table_spec->{search_box_position} : 'before';
}

sub searchable { return keys %{ $_[0]->search_columns } ? 1 : undef; }

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);

    if ($element->attributes->{search}) {
        $self->search_columns->{$element->index} = $element->text;
    }

    return $element;
};

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);

    if ($self->searchable) {
        $table = $self->add_search_box($table);
    }
    
    return $table;
};

sub add_search_box {
    return $_[1];
}

no Moo::Role;

1;

package HTML::TableContent::Template::Search;

use Moo::Role;
use HTML::TableContent::Element;

has searchable => (
    is => 'rw',
    lazy => 1,
);


around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);

    if ($element->attributes->{search}) {
        $self->searchable(1);
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
    my ($self, $table) = @_;

    my $table_name = $self->table_name;
    my $search_box_id = sprintf '%s-input', $table_name;
    my $keyup = sprintf '%sTc.search(this)', $table_name;

    my $search = HTML::TableContent::Element->new({
        html_tag => 'input',
        type => 'text',
        id => $search_box_id,
        onkeyup => $keyup,
        placeholder => 'Search for Something...'
    });

    push @{ $table->before_element }, $search;

    return $table;
}

no Moo::Role;

1;

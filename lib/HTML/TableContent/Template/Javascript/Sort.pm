package HTML::TableContent::Template::Javascript::Sort;

use Moo::Role;

around _add_sort => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);

    $element->onclick(sprintf "%sTc.sortData(this, %s, 'desc')", $self->table_name, $element->index);

    return $element->inner_html(['%s<i>&#9658;</i>']);
};

no Moo::Role;

1;

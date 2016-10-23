package HTML::TableContent::Template::Sort;

use Moo::Role;
use HTML::TableContent::Element;

has sortable => (
    is => 'rw',
    lazy => 1,
);

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);
    
    if ( my $sort = $element->attributes->{sort} ){
        $self->sortable(1);
        if ($sort == 1) {
            $self->_add_sort($element);
        }
    }

    return $element;
};

sub _add_sort {
    my ($self, $element) = @_;

    # ahhhhh
    $element->onclick(sprintf "%sTc.sortData(this, %s, 'desc')", $self->table_name, $element->index);

    return $element->inner_html(['%s<i>&#9658;</i>']);
}

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);

    if ($self->sortable) {
        # ahhh 
        $self->add_sort_js;
    }

    return $table;
};

sub add_sort_js {



}

no Moo::Role;

1;

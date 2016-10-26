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
    return $_[1];
}

no Moo::Role;

1;

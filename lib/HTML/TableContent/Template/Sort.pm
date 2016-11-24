package HTML::TableContent::Template::Sort;

use Moo::Role;
use HTML::TableContent::Element;

has sort_options => (
    is => 'rw',
    lazy => 1,
    default => sub { { } }
);

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);
    
    if ( my $sort = $element->attributes->{sort} ){
        $self->sort_options->{$element->index} = $element->text;
    }

    return $element;
};

around 'last_chance' => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    return defined $self->sort_options ? $self->_add_sort($table) : $table;
};

sub _add_sort {
    return $_[1];
}

no Moo::Role;

1;

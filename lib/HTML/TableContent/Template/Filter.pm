package HTML::TableContent::Template::Filter;

use Moo::Role;
use HTML::TableContent::Element;

has filter_options => (
    is => 'rw',
    lazy => 1,
    default => sub { { } }
);

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);
    
    if (my $filter = $element->attributes->{filter}){
        $self->filter_options->{$element->index} = $element->text;
    }

    return $element;
};

around 'last_chance' => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    return defined $self->filter_options ? $self->_add_filter($table) : $table;
};

sub _add_filter {
    return $_[1];
}

no Moo::Role;

1;

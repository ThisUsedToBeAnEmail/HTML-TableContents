package HTML::TableContent::Template::Util;

use Moo::Role;
use HTML::TableContent::Element;

has [qw/button_options/] => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_button_options {
    return $_[0]->get_table_options('buttons');
}

sub get_table_options {
    my $table_options = $_[0]->table_options;
    return defined $table_options->{$_[1]}
        ? $table_options->{$_[1]}
        : { };
}

around _set_html => sub {
    my ($orig, $self, $args) = @_;
    
    my $element = $self->$orig($args);

    my $tag = $element->tag;
        
    if (my $button_options = $self->button_options->{$tag} || $element->attributes->{buttons}){
        $element = $self->_create_buttons($element, $button_options);
    }   

    return $element;
};

sub _create_buttons {
    return ($_[1], $_[2]);
}

no Moo::Role;

1;

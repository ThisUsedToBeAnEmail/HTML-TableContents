package HTML::TableContent::Template::Catalyst::Util;

use Moo::Role;

around _create_buttons => sub {
    my ($orig, $self, $ele, $args) = @_;

    my ($element, $button_options) = $self->$orig($ele, $args);
    
    return $element unless ref $button_options eq 'ARRAY';
    for (@{ $button_options }) {
        my $sadface = $element;
        if ( $element->tag eq 'row' ) {
            my $cell_args = defined $_->{cell} ? $_->{cell} : { };
            $sadface = $element->add_cell($cell_args);
        }
        my $options = $self->_validate_button_options($_, $sadface);
        $self->add_button($options, $sadface);
    }
    return $element;
};

sub _validate_button_options { 
    my $options = { };
    $options->{link} = defined $_[1]->{link} 
        ? $_[1]->{link}->($_[0], $_[2]) 
        : undef;
    $options->{text} = $_[1]->{text} // 'Button';
    $options->{class} = $_[1]->{class} // 'btn btn-info table-button';
    return $options;
}

sub add_button {
    $_[2]->add_child({
       html_tag => 'a',
       href => $_[1]->{link},
       class => $_[1]->{class},
       role => 'button',
       text => $_[1]->{text},
    });
    return $_[2];
}

no Moo::Role;

1;


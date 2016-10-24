package HTML::TableContent::Template::Catalyst;

use Moo::Role;

has ctx => (
    is => 'ro',
    lazy => 1,
);

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);
        
    if (my $link = $element->attributes->{link}) {
       my $l = $link->($self, $element);
       push @{ $element->links }, $l;
    }
    
    return $element;
};


1;


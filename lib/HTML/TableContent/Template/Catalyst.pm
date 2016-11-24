package HTML::TableContent::Template::Catalyst;

use Moo::Role;

with 'HTML::TableContent::Template::Catalyst::Util';

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

no Moo::Role;

1;


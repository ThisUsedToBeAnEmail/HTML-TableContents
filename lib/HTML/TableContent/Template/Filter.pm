package HTML::TableContent::Template::Filter;

use Moo::Role;
use POSIX qw(ceil);
use HTML::TableContent::Element;

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);

    return $element;
};

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
};


no Moo::Role;

1;

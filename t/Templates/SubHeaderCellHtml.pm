package t::Templates::SubHeaderCellHtml;

use Moo;
use HTML::TableContent::Template;

caption title => (
    class => 'some-class',
    id => 'caption-id',
    text => 'table caption',
);

header id => (
    class => 'some-class',
    id => 'something-id',
    cells => {
        inner_html => 'bold'
    }
);

header name => (
    class => 'okay',
);

header address => (
    class => 'what',
);

sub bold {
    return ['<b>%s</b>'];
}

sub render_header {
    my ($self, $element) = @_;

    return ['<a href="some/endpoint">%s</a>'];
}

sub _data {
    my $self = shift;

    return [
        {
            id => 1,
            name => 'rob',
            address => 'somewhere',
        },
        {
            id => 2,
            name => 'sam',
            address => 'somewhere else',
        },
        {
            id => 3,
            name => 'frank',
            address => 'out',
        },
    ];
}

1;




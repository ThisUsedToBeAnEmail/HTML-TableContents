package t::Templates::AltNuts;

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
        alternate_class => qw/first-head-first-class first-head-second-class first-head-third-class/,
    }
);

header name => (
    class => 'okay',
    cells => {
        alternate_class => qw/second-head-first-class second-head-second-class second-head-third-class/,
    }
);

header address => (
    class => 'what',
    cells => {
        alternate_class => qw/third-head-first-class third-head-second-class third-head-third-class/,
    }
);

row all => (
    alternate_class => qw/first-class second-class third-class/,
);

row one => (
    cells => {
        alternate_class => qw/one two three/,
    }
);

cell all => (
    alternate_class => qw/nuts crazy/,
);

sub _build_data {
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



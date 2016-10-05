package t::TestTemplate;

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
    text => 'id',
);

header name => (
    class => 'okay',
    text => 'name',
);

header address => (
    class => 'what',
    text => 'address'
);

sub data {
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
        }
    ];
}

1;




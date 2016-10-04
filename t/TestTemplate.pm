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
    text => 'user id',
);

header name => (
    class => 'okay',
    text => 'user name',
);

header address => (
    class => 'what',
    text => 'address'
);

sub data {
    my $self = shift;

    return [
        [qw/id name address/],
        [1, 'rob', 'somewhere else'],
        [2, 'sam', 'hallow road']
    ];
}

1;




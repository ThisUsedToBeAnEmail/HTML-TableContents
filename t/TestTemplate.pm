package t::TestTemplate;

use Moo;
use HTML::TableContent::Template;

header id => (
    is => 'ro',
    class => 'some-class',
    id => 'something-id',
    text => 'user id',
    default => q{something}
);

header name => (
    is => 'ro',
    class => 'okay',
    text => 'user name',
);

header address => (
    is => 'ro',
    class => 'what',
    text => 'address'
);

1;




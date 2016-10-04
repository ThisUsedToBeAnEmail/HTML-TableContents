package t::TestTemplate;

use Moo;
use HTML::TableContent::Template;

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

1;




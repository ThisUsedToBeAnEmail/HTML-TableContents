use strict;
use warnings;

use HTML::TableContent;

use Test::More;

my $tc = HTML::TableContent->new();

$tc->add_caption_selectors(qw/content-first content-second/);

use Data::Dumper;

$tc->parse_file('t/html/horizontal/facebook.html');

warn Dumper $tc->get_first_table->caption;

done_testing();

1;

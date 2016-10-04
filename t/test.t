use strict;
use warnings;

use Data::Dumper;

use t::TestTemplate;

my $template = t::TestTemplate->new();

warn Dumper $template->process;

1;

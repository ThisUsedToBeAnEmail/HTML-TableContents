use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('HTML::TableContent');
}

use Data::Dumper;

my $tc = HTML::TableContent->new();

$tc->add_caption_selectors(qw/h3/);

$tc->parse_file('t/html/horizontal/facebook.html');

is($tc->table_count, 17, "correct table count");

is($tc->get_first_table->caption->text, 'Fields', "expected caption text: Fields");

is($tc->get_table(1)->caption->text, 'Edges', "exptect caption text: Edges");

is($tc->get_table(2)->caption->text, 'Validation Rules', "expected caption text: Validation Rules");

is($tc->get_table(3)->caption->text, 'Validation Rules', "expected caption text: Validation Rules");

is($tc->get_table(4)->caption->text, 'Parameters', "expected caption text: Parameters");

done_testing();

1;

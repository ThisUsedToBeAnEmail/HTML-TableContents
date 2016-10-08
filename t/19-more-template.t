use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok("t::Templates::JustHeaders");
    use_ok("t::Templates::HeaderHtml");
    use_ok("t::Templates::HeaderHtmlCustom");
    use_ok("t::Templates::OneHeaderHtml");
    use_ok("t::Templates::SubHeaderHtml");
}

ok(my $template = t::Templates::JustHeaders->new());

is($template->table->header_count, 3, "expected header count");

is($template->id->text, 'id', "expected header id");

is($template->id->get_first_cell->text, '1', "expected header text");

is($template->id->get_first_cell->header->text, 'id', 'text cell header');

is($template->table->get_first_row->get_first_cell->text, '1', "first row first cell text: 1");

is($template->table->get_first_row->get_first_cell->header->text, 'id', "first row first cell header text, id");

my $html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "expected html");

ok($template->id->set_text('User Id'));

is($template->table->header_count, 3, "expected header count");

is($template->id->text, 'User Id', "expected header: User Id");

is($template->id->get_first_cell->text, '1', "expected header text");

is($template->id->get_first_cell->header->text, 'User Id', 'text cell header');

is($template->table->get_first_row->get_first_cell->text, '1', "first row first cell text: 1");

is($template->table->get_first_row->get_first_cell->header->text, 'User Id', "first row first cell header text, User Id");

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">User Id</th><th class="okay">name</th><th class="what">address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "expected html");

is($template->name->text, 'name', "expected header name");

is($template->name->class, 'okay', "expected class: some-class");

is($template->name->id, '', "expected id: something-id");

is($template->name->get_first_cell->text, 'rob', "expected header first cell text: rob");

is($template->name->get_first_cell->header->text, 'name', "cell header text");

is($template->table->get_first_row->get_cell(1)->text, 'rob', "first row first cell text: rob");

is($template->table->get_first_row->get_cell(1)->header->text, 'name', "first row first cell header text: name");

ok($template->name->set_text('User Name'));
ok($template->name->class('test'));
ok($template->name->id('test-id'));
ok($template->name->get_first_cell->set_text('Rex'));

is($template->name->text, 'User Name', "expected header name");

is($template->name->class, 'test', "expected class: test");

is($template->name->id, 'test-id', "expected id: test-id");

is($template->name->get_first_cell->text, 'Rex', "expected header first cell text: rob");

is($template->name->get_first_cell->header->text, 'User Name', "cell header text");

is($template->table->get_first_row->get_cell(1)->text, 'Rex', "first row first cell text: rob");

is($template->table->get_first_row->get_cell(1)->header->text, 'User Name', "first row first cell header text: name");

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">User Id</th><th class="test" id="test-id">User Name</th><th class="what">address</th></tr><tr><td>1</td><td>Rex</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::HeaderHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">id</a></th><th class="okay"><a href="some/endpoint">name</a></th><th class="what"><a href="some/endpoint">address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template->id->set_text('User Id'), 'set id text');

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">User Id</a></th><th class="okay"><a href="some/endpoint">name</a></th><th class="what"><a href="some/endpoint">address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::HeaderHtmlCustom->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint?sort=id">User Id</a></th><th class="okay"><a href="some/endpoint?sort=name">User Name</a></th><th class="what"><a href="some/endpoint?sort=address">User Address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::OneHeaderHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint?sort=id">User Id</a></th><th class="okay">User Name</th><th class="what">User Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::SubHeaderHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint?sort=id">User Id</a></th><th class="okay">User Name</th><th class="what"><a href="some/endpoint?sort=address">User Address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

done_testing();

1;

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
    use_ok("t::Templates::CaptionHtml");
    use_ok("t::Templates::CaptionHtmlCustom");
    use_ok("t::Templates::ArrCaptionHtml");
    use_ok("t::Templates::SubCaptionHtml");
    use_ok("t::Templates::RowHtml");
    use_ok("t::Templates::ArrRowHtml");
    use_ok("t::Templates::SubRowHtml");
    use_ok("t::Templates::CellHtml");
    use_ok("t::Templates::ArrCellHtml");
    use_ok("t::Templates::SubCellHtml");
    use_ok("t::Templates::HeaderCellHtml");
    use_ok("t::Templates::SubHeaderCellHtml");
    use_ok("t::Templates::RowCellHtml");
    use_ok("t::Templates::SubRowCellHtml");
    use_ok("t::Templates::BigData");
    use_ok("t::Templates::TableStuff");
    use_ok("t::Templates::TableInnerStuff");
    use_ok("t::Templates::TableInnerSubStuff");
    use_ok("t::Templates::TableValid5");
    use_ok("t::Templates::TableValid5wrap");
    use_ok("t::Templates::Pagination");
    use_ok("t::Templates::PaginationAbove");
}

ok(my $template = t::Templates::JustHeaders->new());

is($template->table->header_count, 3, "expected header count");

is($template->id->text, 'id', "expected header id");

is($template->id->get_first_cell->text, '1', "expected header text");

is($template->id->get_first_cell->header->text, 'id', 'text cell header');

is($template->table->get_first_row->get_first_cell->text, '1', "first row first cell text: 1");

is($template->table->get_first_row->get_first_cell->header->text, 'id', "first row first cell header text, id");

my $html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "expected html");

ok($template->id->set_text('User Id'));

is($template->table->header_count, 3, "expected header count");

is($template->id->text, 'User Id', "expected header: User Id");

is($template->id->get_first_cell->text, '1', "expected header text");

is($template->id->get_first_cell->header->text, 'User Id', 'text cell header');

is($template->table->get_first_row->get_first_cell->text, '1', "first row first cell text: 1");

is($template->table->get_first_row->get_first_cell->header->text, 'User Id', "first row first cell header text, User Id");

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">User Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "expected html");

is($template->name->text, 'name', "expected header name");

is($template->name->class, 'okay', "expected class: some-class");

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

is($template->name->get_first_cell->text, 'Rex', "expected header first cell text: Rex");

is($template->name->get_first_cell->header->text, 'User Name', "cell header text");

is($template->table->get_first_row->get_cell(1)->text, 'Rex', "first row first cell text: Rex");

is($template->table->get_first_row->get_cell(1)->header->text, 'User Name', "first row first cell header text: name");

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">User Id</th><th class="test" id="test-id">User Name</th><th class="what">Address</th></tr><tr><td>1</td><td>Rex</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::HeaderHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">Id</a></th><th class="okay"><a href="some/endpoint">Name</a></th><th class="what"><a href="some/endpoint">Address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template->id->set_text('User Id'), 'set id text');

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">User Id</a></th><th class="okay"><a href="some/endpoint">Name</a></th><th class="what"><a href="some/endpoint">Address</a></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

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

ok($template = t::Templates::CaptionHtml->new());

$html = '<table><caption class="some-class" id="caption-id"><a href="some/endpoint">table caption</a></caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::CaptionHtmlCustom->new());

$html = '<table><caption class="some-class" id="caption-id"><a href="www.somelinktosomethingspecial.com">table caption</a></caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::ArrCaptionHtml->new());

$html = '<table><caption class="some-class" id="caption-id"><a href="www.somelinktosomethingspecial.com">table caption</a></caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::SubCaptionHtml->new());

$html = '<table><caption class="some-class" id="caption-id"><a href="www.somelinktosomethingspecial.com">table caption</a></caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::RowHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><td>1</td><td>rob</td><td>somewhere</td></div></tr><tr><div><td>2</td><td>sam</td><td>somewhere else</td></div></tr><tr><div><td>3</td><td>frank</td><td>out</td></div></tr></table>';

is($template->render, $html, "$html");


ok($template = t::Templates::ArrRowHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><a href="some/endpoint"><td>1</td><td>rob</td><td>somewhere</td></a></div></tr><tr><div><td>2</td><td>sam</td><td>somewhere else</td></div></tr><tr><div><td>3</td><td>frank</td><td>out</td></div></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::SubRowHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><a href="some/endpoint"><td>1</td><td>rob</td><td>somewhere</td></a></div></tr><tr><div><td>2</td><td>sam</td><td>somewhere else</td></div></tr><tr><div><td>3</td><td>frank</td><td>out</td></div></tr></table>';

is($template->render, $html, "$html");


ok($template = t::Templates::CellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><td><span>1</span></td><td><span>rob</span></td><td><span>somewhere</span></td></div></tr><tr><div><td><span>2</span></td><td><span>sam</span></td><td><span>somewhere else</span></td></div></tr><tr><div><td><span>3</span></td><td><span>frank</span></td><td><span>out</span></td></div></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::ArrCellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><td><span><a href="some/endpoint">1</a></span></td><td><span>rob</span></td><td><span>somewhere</span></td></div></tr><tr><div><td><span>2</span></td><td><span>sam</span></td><td><span>somewhere else</span></td></div></tr><tr><div><td><span>3</span></td><td><span>frank</span></td><td><span>out</span></td></div></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::SubCellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><td><span><a href="some/endpoint">1</a></span></td><td><span>rob</span></td><td><span>somewhere</span></td></div></tr><tr><div><td><span>2</span></td><td><span>sam</span></td><td><span>somewhere else</span></td></div></tr><tr><div><td><span>3</span></td><td><span>frank</span></td><td><span>out</span></td></div></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::HeaderCellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">Id</a></th><th class="okay"><a href="some/endpoint">Name</a></th><th class="what"><a href="some/endpoint">Address</a></th></tr><tr><td><b>1</b></td><td>rob</td><td>somewhere</td></tr><tr><td><b>2</b></td><td>sam</td><td>somewhere else</td></tr><tr><td><b>3</b></td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::SubHeaderCellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id"><a href="some/endpoint">Id</a></th><th class="okay"><a href="some/endpoint">Name</a></th><th class="what"><a href="some/endpoint">Address</a></th></tr><tr><td><b>1</b></td><td>rob</td><td>somewhere</td></tr><tr><td><b>2</b></td><td>sam</td><td>somewhere else</td></tr><tr><td><b>3</b></td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::RowCellHtml->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><div><td><span id="first-id">1</span></td><td><span id="first-name">rob</span></td><td><span id="first-address">somewhere</span></td></div></tr><tr><div><td>2</td><td>sam</td><td>somewhere else</td></div></tr><tr><div><td>3</td><td>frank</td><td>out</td></div></tr></table>';

is($template->render, $html, "$html");

my %hash = (
    id => '1',
    name => 'rob',
    address => 'thing',
);

my $data = [ ];
for ( 0 .. 1000 ) {
    $hash{counting} = $_;
    push @{ $data }, \%hash;
}

ok($template = t::Templates::BigData->new({ data => $data }));

is($template->table->row_count, '1001', "expected row count: 1001");
is($template->table->get_first_row->class, 'thing', "expected class: thing");
is($template->table->get_last_row->class, 'one_thousand_one', "expected class: one_thousand_one");
is($template->table->get_row(99)->class, 'hundred', "expected class: hundred");
is($template->table->get_row(149)->class, 'one_hundred_fifty', "expected class: one_hundred_fifty");

ok($template = t::Templates::TableStuff->new());
ok(my $t = $template->table);

is($t->class, "some-table-class", "okay table class");
is($t->id, "some-table-id", "okay table id");

$html = '<table class="some-table-class" id="some-table-id"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::TableInnerStuff->new());

$html = '<table class="some-table-class" id="some-table-id"><div><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></div></table>';

ok($template = t::Templates::TableInnerSubStuff->new());

$html = '<table class="some-table-class" id="some-table-id"><div><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></div></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::TableValid5->new());

$html = '<table class="some-table-class" id="some-table-id"><caption class="some-class" id="caption-id">table caption</caption><thead><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr></thead><tbody><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></tbody></table>';

is($template->render, $html, "$html");

ok($template = t::Templates::TableValid5wrap->new());

$html = '<div class="responsive"><table class="some-table-class" id="some-table-id"><caption class="some-class" id="caption-id">table caption</caption><thead><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr></thead><tbody><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></tbody></table></div>';

is($template->render, $html, "$html");

ok($template = t::Templates::Pagination->new());

is($template->page_count, 3, "expected page count 3");

$html = '<div><table id="paginationTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr><tr><td>4</td><td>rob</td><td>somewhere</td></tr><tr><td>5</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>6</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>7</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>8</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>9</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>10</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>11</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>12</td><td>frank</td><td>out</td></tr></table><div><ul class="pagination"><li><a href="#" id="tc<" class="tc-normal" onclick="paginationPager.prev();"><</a></li><li><a href="#" id="tc1" class="tc-selected" onclick="paginationPager.showPage(1)">1</a></li><li><a href="#" id="tc2" class="tc-normal" onclick="paginationPager.showPage(2);">2</a></li><li><a href="#" id="tc3" class="tc-normal" onclick="paginationPager.showPage(3);">3</a></li><li><a href="#" id="tc>" class="tc-normal" onclick="paginationPager.next();">></a></li></ul></div><script type="text/javascript">var paginationPager = new Pager("paginationTable", 5, 3);</script></div>';

is($template->render, $html, "expected html $html");

my $js = '<script type="text/javascript">function Pager(tableName, itemsPerPage, totalPages) { this.tableName = tableName; this.itemsPerPage = itemsPerPage; this.currentPage = 1; this.pages = totalPages; this.showRecords = function(from, to) { var rows = document.getElementById(tableName).rows; for (var i = 1; i < rows.length; i++) { if (i < from || i > to) rows[i].style.display = \'none\'; else rows[i].style.display = \'\'; } } this.showPage = function(pageNumber) { var oldPageAnchor = document.getElementById(\'tc\'+this.currentPage); oldPageAnchor.className = \'tc-normal\'; this.currentPage = pageNumber; var newPageAnchor = document.getElementById(\'tc\'+this.currentPage); newPageAnchor.className = \'tc-selected\'; var from = (pageNumber - 1) * itemsPerPage + 1; var to = from + itemsPerPage - 1; this.showRecords(from, to); } this.prev = function() { if (this.currentPage > 1) { this.showPage(this.currentPage - 1); } } this.next = function() { if (this.currentPage < this.pages) { this.showPage(this.currentPage + 1); } } }</script>';

is($template->render_header_js, $js, "expected js $js");

ok($template = t::Templates::Pagination->new(data => $data), 'new with lots of data');

is($template->page_count, 201, "expected page count 21");

ok($template = t::Templates::PaginationAbove->new());

is($template->page_count, 3, "expected page count 3");

$html = '<div><div><ul class="pagination"><li><a href="#" id="tc<" class="tc-normal" onclick="paginationabovePager.prev();"><</a></li><li><a href="#" id="tc1" class="tc-selected" onclick="paginationabovePager.showPage(1)">1</a></li><li><a href="#" id="tc2" class="tc-normal" onclick="paginationabovePager.showPage(2);">2</a></li><li><a href="#" id="tc3" class="tc-normal" onclick="paginationabovePager.showPage(3);">3</a></li><li><a href="#" id="tc>" class="tc-normal" onclick="paginationabovePager.next();">></a></li></ul></div><table id="paginationaboveTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr><tr><td>4</td><td>rob</td><td>somewhere</td></tr><tr><td>5</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>6</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>7</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>8</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>9</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>10</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>11</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>12</td><td>frank</td><td>out</td></tr></table><script type="text/javascript">var paginationabovePager = new Pager("paginationaboveTable", 5, 3);</script></div>';

is($template->render, $html, "okay html - $html");

done_testing();

1;

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
    use_ok("t::Templates::Sort");
    use_ok("t::Templates::Search");
    use_ok("t::Templates::JS");
    use_ok("t::Templates::VerticalHeaders");
}

ok(my $template = t::Templates::JustHeaders->new());

warn Dumper $template;

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

$html = '<div><table id="paginationTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr><tr><td>4</td><td>rob</td><td>somewhere</td></tr><tr><td>5</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>6</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>7</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>8</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>9</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>10</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>11</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>12</td><td>frank</td><td>out</td></tr></table><div><ul class="pagination"><li><a href="#" id="tc<" class="tc-normal" onclick="paginationTc.prev(); return false;"><</a></li><li><a href="#" id="tc1" class="tc-selected" onclick="paginationTc.showPage(1); return false;">1</a></li><li><a href="#" id="tc2" class="tc-normal" onclick="paginationTc.showPage(2); return false;">2</a></li><li><a href="#" id="tc3" class="tc-normal" onclick="paginationTc.showPage(3); return false;">3</a></li><li><a href="#" id="tc>" class="tc-normal" onclick="paginationTc.next(); return false;">></a></li></ul></div><script type="text/javascript">var paginationTc = new HtmlTC("paginationTable", 5, {});</script></div>';

is($template->render, $html, "expected html $html");

my $js = '<script type="text/javascript">function HtmlTC(a,b){this.tableName=a,this.itemsPerPage=b,this.currentPage=1,this.pages=0,this.searched=0,this.showRecords=function(b,c){for(var d=document.getElementById(a).rows,e=0,f=1;f<d.length;f++)d[f].classList.contains("search-hide")||e++,f<b||f>c?d[f].style.display="none":d[f].style.display="";return this.paginationPages(e)},this.paginationPages=function(a){for(var b=document.getElementsByClassName("pg-normal"),c=0;c<b.length;c++)a-=this.itemsPerPage,a<=0?b[c].classList.add("search-hide"):b[c].classList.remove("search-hide")},this.showPage=function(a){var c=document.getElementById("pg"+this.currentPage);c.className="pg-normal",this.currentPage=a;var d=document.getElementById("pg"+this.currentPage);d.className="pg-selected";var e=(a-1)*b+1,f=e+b-1;this.showRecords(e,f)},this.prev=function(){this.currentPage>1&&this.showPage(this.currentPage-1)},this.next=function(){this.currentPage<this.pages&&this.showPage(this.currentPage+1)},this.sortData=function(b,c,d){var e=document.getElementById(a);e.tBodies.length&&(e=e.tBodies[0]);for(var f=e.rows,g=[],h=1;h<f.length;h++){var i=f[h],j=i.cells[c].textContent||i.cells[c].innerText;g.push([j,i])}"desc"==d?(g.sort(this.sortdesc),b.setAttribute("onclick","Tc.sortData(this, "+c+", \'asc\')")):(g.sort(this.sortasc),b.setAttribute("onclick","Tc.sortData(this, "+c+", \'desc\')"));for(var h=0;h<g.length;h++)e.appendChild(g[h][1]);g=null,this.setSortArrow(b,d),1===this.searched?this.search:this.showPage(this.currentPage)},this.setSortArrow=function(b,c){for(var d=document.getElementById(a).rows[0].cells,e=0;e<d.length;e++){var f=d[e],g="►";f.innerHTML==b.innerHTML&&(g="desc"==c?"▲":"▼"),f.children[0].innerHTML=f.children[0].innerHTML.replace(/[\u25bc 25b2 25ba]/g,g)}},this.search=function(b){var c=b.value.toUpperCase(),d=document.getElementById(a);c?this.searched=1:this.searched=0,d.tBodies.length&&(d=d.tBodies[0]);for(var e=[],f=1;f<d.rows.length;f++){for(var g=d.rows[f],h=g.cells,i=0;i<h.length;i++){var j=h[i];if(j.innerHTML.toUpperCase().indexOf(c)>-1){g.classList.remove("search-hide"),e.push([10,g]);break}}e.length&&e[e.length-1][1].cells[0].innerHTML===h[0].innerHTML||(g.classList.add("search-hide"),e.push([1,g]))}e.sort(this.sortdesc);for(var f=0;f<e.length;f++){var g=e[f][1];d.appendChild(g)}e=null,this.showPage(this.currentPage)},this.sortdesc=function(a,b){return isNaN(a[0])?b[0]<a[0]?-1:b[0]>a[0]?1:0:b[0]-a[0]},this.sortasc=function(a,b){return isNaN(a[0])?a[0]<b[0]?-1:a[0]>b[0]?1:0:a[0]-b[0]}}</script>';

#is($template->render_header_js, $js, "expected js $js");

ok($template = t::Templates::Pagination->new(data => $data), 'new with lots of data');

is($template->page_count, 201, "expected page count 21");

ok($template = t::Templates::PaginationAbove->new());

is($template->page_count, 3, "expected page count 3");

$html = '<div><div><ul class="pagination"><li><a href="#" id="tc<" class="tc-normal" onclick="paginationaboveTc.prev(); return false;"><</a></li><li><a href="#" id="tc1" class="tc-selected" onclick="paginationaboveTc.showPage(1); return false;">1</a></li><li><a href="#" id="tc2" class="tc-normal" onclick="paginationaboveTc.showPage(2); return false;">2</a></li><li><a href="#" id="tc3" class="tc-normal" onclick="paginationaboveTc.showPage(3); return false;">3</a></li><li><a href="#" id="tc>" class="tc-normal" onclick="paginationaboveTc.next(); return false;">></a></li></ul></div><table id="paginationaboveTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr><tr><td>4</td><td>rob</td><td>somewhere</td></tr><tr><td>5</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>6</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>7</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>8</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>9</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>10</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>11</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>12</td><td>frank</td><td>out</td></tr></table><script type="text/javascript">var paginationaboveTc = new HtmlTC("paginationaboveTable", 5, {});</script></div>';

is($template->render, $html, "okay html - $html");

ok($template = t::Templates::Sort->new());

$html = '<table id="sortTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id<i onclick="sortTc.sortData(this, 0, \'desc\')">&#9658;</i></th><th class="okay">Name<i onclick="sortTc.sortData(this, 1, \'desc\')">&#9658;</i></th><th class="what">Address<i onclick="sortTc.sortData(this, 2, \'desc\')">&#9658;</i></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table><script type="text/javascript">var sortTc = new HtmlTC("sortTable", 3, {});</script>';

is($template->render, $html, "okay basic sort html - $html");

ok($template = t::Templates::Search->new());

$html = '<input id="search-input" type="text" onkeyup="searchTc.search(this)" placeholder="Search for Something..."></input><table id="searchTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><th class="okay">Name</th><th class="what">Address</th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr></table><script type="text/javascript">var searchTc = new HtmlTC("searchTable", 3, 1);</script>';

is($template->render, $html, "okay basic search html - $html");

ok($template = t::Templates::JS->new());

$html = '<div><input id="js-input" type="text" onkeyup="jsTc.search(this)" placeholder="Search for Something..."></input><table id="jsTable"><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id" onclick="jsTc.sortData(this, 0, \'desc\')">Id<i>&#9658;</i></th><th class="okay" onclick="jsTc.sortData(this, 1, \'desc\')">Name<i>&#9658;</i></th><th class="what" onclick="jsTc.sortData(this, 2, \'desc\')">Address<i>&#9658;</i></th></tr><tr><td>1</td><td>rob</td><td>somewhere</td></tr><tr><td>2</td><td>sam</td><td>somewhere else</td></tr><tr><td>3</td><td>frank</td><td>out</td></tr><tr><td>4</td><td>rob</td><td>somewhere</td></tr><tr><td>5</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>6</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>7</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>8</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>9</td><td>frank</td><td>out</td></tr><tr style="display:none;"><td>10</td><td>rob</td><td>somewhere</td></tr><tr style="display:none;"><td>11</td><td>sam</td><td>somewhere else</td></tr><tr style="display:none;"><td>12</td><td>frank</td><td>out</td></tr></table><div><ul class="pagination"><li><a href="#" id="tc<" class="tc-normal" onclick="jsTc.prev();"><</a></li><li><a href="#" id="tc1" class="tc-selected" onclick="jsTc.showPage(1)">1</a></li><li><a href="#" id="tc2" class="tc-normal" onclick="jsTc.showPage(2);">2</a></li><li><a href="#" id="tc3" class="tc-normal" onclick="jsTc.showPage(3);">3</a></li><li><a href="#" id="tc>" class="tc-normal" onclick="jsTc.next();">></a></li></ul></div><script type="text/javascript">var jsTc = new HtmlTC("jsTable", 5, 3);</script></div>';

is($template->render, $html, "okay all of the above - html");

ok($template = t::Templates::VerticalHeaders->new());

$html = '<table><caption class="some-class" id="caption-id">table caption</caption><tr><th class="some-class" id="something-id">Id</th><td>1</td><td>2</td><td>3</td></tr><tr><th class="okay">Name</th><td>rob</td><td>sam</td><td>frank</td></tr><tr><th class="what">Address</th><td>somewhere</td><td>somewhere else</td><td>out</td></tr></table>';

is($template->render, $html, "expected html - $html");

done_testing();

1;

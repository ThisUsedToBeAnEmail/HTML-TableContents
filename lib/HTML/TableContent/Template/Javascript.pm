package HTML::TableContent::Template::Javascript;

use Moo::Role;

with 'HTML::TableContent::Template::Javascript::Paginate';
with 'HTML::TableContent::Template::Javascript::Sort';
with 'HTML::TableContent::Template::Javascript::Search';

after last_chance => sub {
    my ($self, $table) = @_;

    if ($self->sortable || $self->searchable || $self->pagination) {
        $self->add_pager_js($table);
    }   
    return $table 
};

sub add_pager_js {
    my $table_id;
    unless ($table_id = $_[1]->id ) {
        $table_id = sprintf '%sTable', $_[0]->table_name;
        $_[1]->id($table_id);
    }
    my $display = defined $_[1]->attributes->{display} ? $_[1]->attributes->{display} : $_[1]->row_count;

    my $table_script = sprintf '<script type="text/javascript">var %sTc = new HtmlTC("%s", %s, %s);</script>', 
       $_[0]->table_name, $table_id, $display, $_[0]->page_count // 1;

    push @{ $_[1]->after_element }, $table_script;
    
    return $_[1];
}

sub render_header_js {
    my $js = 'function HtmlTC(tableName, itemsPerPage) {
    this.tableName = tableName;
    this.itemsPerPage = itemsPerPage;
    this.currentPage = 1;
    this.pages = 0;
    this.searched = 0;
    this.showRecords = function(from, to) {
        var rows = document.getElementById(tableName).rows;
        var active = 0;
        // i starts from 1 to skip table header row
        for (var i = 1; i < rows.length; i++) {
            if (!rows[i].classList.contains(\'search-hide\')) active++;
            if (i < from || i > to)
                rows[i].style.display = \'none\';
            else
                rows[i].style.display = \'\';
        }

        return this.paginationPages(active);
    }
    this.paginationPages = function(active) {
        var pages = document.getElementsByClassName(\'tc-normal\');

        for (var i = 0; i < pages.length; i++) {
            console.log(pages[i].innerText);
            if (pages[i].innerText == /\d/g) {
                active = active - this.itemsPerPage;
                active <= -5
                    ? pages[i].classList.add(\'search-hide\')
                    : pages[i].classList.remove(\'search-hide\');
            }
        }
    }
    this.showPage = function(pageNumber) {

        var oldPageAnchor = document.getElementById(\'tc\'+this.currentPage);

        oldPageAnchor.className = \'tc-normal\';

        this.currentPage = pageNumber;

        var newPageAnchor = document.getElementById(\'tc\'+this.currentPage);

        newPageAnchor.className = \'tc-selected\';

        var from = (pageNumber - 1) * itemsPerPage + 1;

        var to = from + itemsPerPage - 1;

        this.showRecords(from, to);

    }
    this.prev = function() {
        if (this.currentPage > 1) this.showPage(this.currentPage - 1);
    }
    this.next = function() {
       if (this.currentPage > this.pages) this.showPage(this.currentPage + 1);
    }
    this.sortData = function(ele, col, action) {
        var tbl = document.getElementById(tableName);
        var rows;
        if (tbl.tBodies.length) {
            tbl = tbl.tBodies[0];
            rows = tbl.rows;
        } else {
            rows = tbl.rows;
            rows.shift();
        }

        var store = [];
        for (var i=0; i < rows.length; i++){
            var row = rows[i];
            var sortnr = row.cells[col].textContent || row.cells[col].innerText;

            store.push([sortnr.toLowerCase(), row]);
        }

        if ( action == \'desc\') {
            store.sort(this.sortdesc);
            ele.attributes.onclick.nodeValue = ele.attributes.onclick.nodeValue.replace(/desc/, \'asc\');
        } else {
            store.sort(this.sortasc);
            ele.attributes.onclick.nodeValue = ele.attributes.onclick.nodeValue.replace(/asc/, \'desc\');
        }

        for(var i=0; i < store.length; i++) {
            tbl.appendChild(store[i][1]);
        }
        store = null;

        this.setSortArrow(ele, action);

        if (this.searched === 1)  this.search;
        else this.showPage(this.currentPage);
    }
    this.setSortArrow = function (ele, action) {
        var headers = document.getElementById(tableName).rows[0].cells;

        console.log(headers);

        for (var i=0; i < headers.length; i++) {
            var cell = headers[i];

            var change = \'\u25ba\';
            if (cell.innerHTML == ele.innerHTML) {
                change = action == \'desc\' ? \'\u25b2\' : \'\u25bc\';
            }

            cell.children[0].innerHTML = cell.children[0].innerHTML.replace(/[\u25bc \u25b2 \u25ba]/g, change);  
        }

        return;
    }
    this.search = function (ele) {
        var input = ele.value.toUpperCase();
        var tbl = document.getElementById(tableName);

        if (!input) this.searched = 0;
        else this.searched = 1;

        var rows;
        if (tbl.tBodies.length) {
            tbl = tbl.tBodies[0];
            rows = tbl.rows;
        } else {
            rows = tbl.rows;
            rows.shift();
        }

        var match = [];
        for ( var i=0; i < rows.length; i++ ) {
            var row = rows[i];
            var cells = row.cells;
            for ( var c=0; c < cells.length; c++ ) {
                var cell = cells[c];
                if (cell.innerHTML.toUpperCase().indexOf(input) > -1) {
                    row.classList.remove(\'search-hide\');
                    match.push([10, row]);
                    break;
                }
            }

            if ( ! match.length || match[match.length - 1][1].cells[0].innerHTML !== cells[0].innerHTML ){
                row.classList.add(\'search-hide\');
                match.push([1, row]);
            }
        }

        match.sort(this.sortdesc);

        for(var i=0; i < match.length; i++) {
            var row = match[i][1];
            tbl.appendChild(row);
        }

        match = null;

        this.showPage(this.currentPage);
    }
    this.sortdesc = function (a, b){
        if(isNaN(a[0])) {
            if (b[0] < a[0]) return -1;
            else if (b[0] > a[0]) return  1;
            else return 0;
         } else {
            return b[0] - a[0];
        }
    }
    this.sortasc = function (a, b) {
        if(isNaN(a[0])) {
            if (a[0] < b[0]) return -1;
            else if (a[0] > b[0]) return  1;
            else return 0;
        } else {
            return a[0] - b[0];
        }
    }
}';

    return sprintf '<style>.search-hide{ display: none; }</style><script type="text/javascript">%s</script>', $js;
}

1;

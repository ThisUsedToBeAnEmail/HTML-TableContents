package HTML::TableContent::Template::Javascript;

use Moo::Role;

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
    my $js = "function HtmlTC(a,b){this.tableName=a,this.itemsPerPage=b,this.currentPage=1,this.pages=0,this.searched=0,this.showRecords=function(b,c){for(var d=document.getElementById(a).rows,e=0,f=1;f<d.length;f++)d[f].classList.contains(\"search-hide\")||e++,f<b||f>c?d[f].style.display=\"none\":d[f].style.display=\"\";return this.paginationPages(e)},this.paginationPages=function(a){for(var b=document.getElementsByClassName(\"pg-normal\"),c=0;c<b.length;c++)a-=this.itemsPerPage,a<=0?b[c].classList.add(\"search-hide\"):b[c].classList.remove(\"search-hide\")},this.showPage=function(a){var c=document.getElementById(\"pg\"+this.currentPage);c.className=\"pg-normal\",this.currentPage=a;var d=document.getElementById(\"pg\"+this.currentPage);d.className=\"pg-selected\";var e=(a-1)*b+1,f=e+b-1;this.showRecords(e,f)},this.prev=function(){this.currentPage>1&&this.showPage(this.currentPage-1)},this.next=function(){this.currentPage<this.pages&&this.showPage(this.currentPage+1)},this.sortData=function(b,c,d){var e=document.getElementById(a);e.tBodies.length&&(e=e.tBodies[0]);for(var f=e.rows,g=[],h=1;h<f.length;h++){var i=f[h],j=i.cells[c].textContent||i.cells[c].innerText;g.push([j,i])}\"desc\"==d?(g.sort(this.sortdesc),b.setAttribute(\"onclick\",\"Tc.sortData(this, \"+c+\", 'asc')\")):(g.sort(this.sortasc),b.setAttribute(\"onclick\",\"Tc.sortData(this, \"+c+\", 'desc')\"));for(var h=0;h<g.length;h++)e.appendChild(g[h][1]);g=null,this.setSortArrow(b,d),1===this.searched?this.search:this.showPage(this.currentPage)},this.setSortArrow=function(b,c){for(var d=document.getElementById(a).rows[0].cells,e=0;e<d.length;e++){var f=d[e],g=\"►\";f.innerHTML==b.innerHTML&&(g=\"desc\"==c?\"▲\":\"▼\"),f.children[0].innerHTML=f.children[0].innerHTML.replace(/[\\u25bc \u25b2 \u25ba]/g,g)}},this.search=function(b){var c=b.value.toUpperCase(),d=document.getElementById(a);c?this.searched=1:this.searched=0,d.tBodies.length&&(d=d.tBodies[0]);for(var e=[],f=1;f<d.rows.length;f++){for(var g=d.rows[f],h=g.cells,i=0;i<h.length;i++){var j=h[i];if(j.innerHTML.toUpperCase().indexOf(c)>-1){g.classList.remove(\"search-hide\"),e.push([10,g]);break}}e.length&&e[e.length-1][1].cells[0].innerHTML===h[0].innerHTML||(g.classList.add(\"search-hide\"),e.push([1,g]))}e.sort(this.sortdesc);for(var f=0;f<e.length;f++){var g=e[f][1];d.appendChild(g)}e=null,this.showPage(this.currentPage)},this.sortdesc=function(a,b){return isNaN(a[0])?b[0]<a[0]?-1:b[0]>a[0]?1:0:b[0]-a[0]},this.sortasc=function(a,b){return isNaN(a[0])?a[0]<b[0]?-1:a[0]>b[0]?1:0:a[0]-b[0]}}";

    return sprintf '<script type="text/javascript">%s</script>', $js;
}

1;

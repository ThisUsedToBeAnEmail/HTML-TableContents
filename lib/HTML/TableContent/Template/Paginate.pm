package HTML::TableContent::Template::Paginate;

use Moo::Role;
use POSIX qw(ceil);
use HTML::TableContent::Element;
use feature qw/switch/;
no warnings 'experimental';

has [qw/page_count display pagination/] => (
    is => 'rw',
);

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);
    my $table_options = $self->table_options;

    if ( $table_options->{pagination} ) {
        if ( $element->tag eq 'row' && $element->row_index > $table_options->{display} ) { 
            $element->style("display:none;");
        }
    }

    return $element;
};

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    my $table_options = $self->table_options;
    if (exists $table_options->{pagination}){
        $table = $self->setup_pagination($table, $table_options);
    }   
    return $table 
};

## Could refactor the below into - Table

sub setup_pagination {
    my ($self, $table, $table_options) = @_;

    my $row_count = $table->row_count;
    
    if ( $row_count > $table_options->{display} ) {
        my $pager_name = $self->pager_name($table);
        my $page_count = ceil($row_count / $table_options->{display});
        $self->page_count($page_count);

        my $pagination = HTML::TableContent::Element->new({ html_tag => 'ul', class => 'pagination' });
        $pagination->wrap_html(['<div>%s</div>']);

        my $back = $pagination->add_child({ html_tag => 'li', text => '<', tag => $pager_name });
        $back = $self->set_inner_pager_item_html($back);

        for (1 .. $page_count) {
            my $page = $pagination->add_child({ html_tag => 'li', text => $_, tag => $pager_name });
            $page = $self->set_inner_pager_item_html($page); 
        }

        my $forward = $pagination->add_child({ html_tag => 'li', text => '>', tag => $pager_name });
        $forward = $self->set_inner_pager_item_html($forward);

        if ( $table_options->{pagination} =~ m{after_element|before_element}xms ) {
            my $action = $table_options->{pagination};
            push @{ $table->$action }, $pagination;
        } else {
            push @{ $table->after_element }, $pagination;
        }

        $self->add_pager_js($table, $pager_name, $page_count);
    }
    
    return $table;
}

sub set_inner_pager_item_html {
    given ($_[1]->text) {
        when (/1/) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-selected" onclick="%sPager.showPage(%s)">%s</a>', 'text', 'tag', 'text', 'text']);
        }
        when (/</) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sPager.prev();">%s</a>', 'text', 'tag', 'text']);
        }
        when (/>/) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sPager.next();">%s</a>', 'text', 'tag', 'text']);
        }
        default {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sPager.showPage(%s);">%s</a>', 'text', 'tag', 'text', 'text']);
        }
    } 
    return $_[1];
}

sub add_pager_js {
    my $table_script = sprintf '<script type="text/javascript">var %sPager = new Pager("%s", %s, %s);</script>', 
       $_[2], $_[1]->id, $_[1]->attributes->{display}, $_[3];

    push @{ $_[1]->after_element }, $table_script;
   
    $_[0]->add_pager_header_js;
    
    return $_[1];
}

sub pager_name {
    if ( $_[1]->has_id ) {
        return $_[1]->id;
    }
    else {
        my ( $package_name ) = (lc $_[0]->package) =~ /.*\:\:(.*)/;
        $_[1]->id($package_name . 'Table');
        return $package_name;
    }
}

sub add_pager_header_js {
    my $js = "function Pager(tableName, itemsPerPage, totalPages) { this.tableName = tableName; this.itemsPerPage = itemsPerPage; this.currentPage = 1; this.pages = totalPages; this.showRecords = function(from, to) { var rows = document.getElementById(tableName).rows; for (var i = 1; i < rows.length; i++) { if (i < from || i > to) rows[i].style.display = 'none'; else rows[i].style.display = ''; } } this.showPage = function(pageNumber) { var oldPageAnchor = document.getElementById('tc'+this.currentPage); oldPageAnchor.className = 'tc-normal'; this.currentPage = pageNumber; var newPageAnchor = document.getElementById('tc'+this.currentPage); newPageAnchor.className = 'tc-selected'; var from = (pageNumber - 1) * itemsPerPage + 1; var to = from + itemsPerPage - 1; this.showRecords(from, to); } this.prev = function() { if (this.currentPage > 1) { this.showPage(this.currentPage - 1); } } this.next = function() { if (this.currentPage < this.pages) { this.showPage(this.currentPage + 1); } } }";

    push @{ $_[0]->header_js }, $js;
}

no Moo::Role;

1;

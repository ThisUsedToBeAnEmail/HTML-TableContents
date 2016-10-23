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
            $self->pagination(1);
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
        my $pager_name = $self->table_name;
        $table->id(sprintf '%sTable', $pager_name);
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
    }
    
    return $table;
}

sub set_inner_pager_item_html {
    given ($_[1]->text) {
        when (/1/) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-selected" onclick="%sTc.showPage(%s)">%s</a>', 'text', 'tag', 'text', 'text']);
        }
        when (/</) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sTc.prev();">%s</a>', 'text', 'tag', 'text']);
        }
        when (/>/) {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sTc.next();">%s</a>', 'text', 'tag', 'text']);
        }
        default {
            $_[1]->inner_html(['<a href="#" id="tc%s" class="tc-normal" onclick="%sTc.showPage(%s);">%s</a>', 'text', 'tag', 'text', 'text']);
        }
    } 
    return $_[1];
}


no Moo::Role;

1;

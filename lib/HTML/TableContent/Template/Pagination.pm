package HTML::TableContent::Template::Pagination;

use Moo::Role;
use POSIX qw(ceil);
use HTML::TableContent::Element;

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
    return $table unless exists $table_options->{pagination};

    my $row_count = $table->row_count;
    
    if ( $row_count > $table_options->{display} ) {
        my $page_count = ceil($row_count / $table_options->{display});
        my $pagination = HTML::TableContent::Element->new({ html_tag => 'ul' });
        $pagination->wrap_html(['<div>%s</div>']);

        my @pages = ( );
        for (1 .. $page_count) {
            my $page = $pagination->add_child({ html_tag => 'li', text => $_ });
            $page->inner_html(['<a href="#">%s</a>']);
        }

        if ( $table_options->{pagination} =~ m{after_element|before_element}xms ) {
            my $action = $table_options->{pagination};
            push @{ $table->$action }, $pagination;
        } else {
            push @{ $table->after_element }, $pagination;
        }
    }

    return $table 
};

has pager_name => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_pager_name {
    if ( $_[0]->table->has_id ) {
        return $_[0]->table->id;
    }
    else {
        my ( $package_name ) = (lc $_[0]->package) =~ /.*\:\:(.*)/;
        $_[0]->table->id($package_name);
        return $package_name;
    }
}

no Moo::Role;

1;

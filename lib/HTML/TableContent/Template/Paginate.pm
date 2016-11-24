package HTML::TableContent::Template::Paginate;

use Moo::Role;
use POSIX qw(ceil);
use HTML::TableContent::Element;
use feature qw/switch/;
no warnings 'experimental';

has pagination => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_pagination {
    my $self = shift;

    my $table_options = $self->table_options;
    return $table_options->{pagination} ? 1 : undef;
}

has page_count => (
    is => 'rw',
);

sub set_page_count {
    my ($self, $row_count) = @_; 

    my $page_count = ceil($row_count / $self->highest_display);
    $self->page_count($page_count);
    return $page_count;
}

around _set_html => sub {
    my ($orig, $self, $args) = @_;

    my $element = $self->$orig($args);

    if ( $self->pagination ) {
        if ( $element->tag eq 'row' && $element->row_index > $self->display ) { 
            $element->style("display:none;");
        }
    }

    return $element;
};

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    if (exists $self->table_options->{pagination}){
        $table = $self->setup_pagination($table);
    }   
    return $table 
};

## Could refactor the below into - Table
sub setup_pagination {
    return $_[1];
}

no Moo::Role;

1;

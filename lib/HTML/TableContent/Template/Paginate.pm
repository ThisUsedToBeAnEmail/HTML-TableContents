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

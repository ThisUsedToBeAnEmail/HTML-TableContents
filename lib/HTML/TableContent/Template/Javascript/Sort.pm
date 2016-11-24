package HTML::TableContent::Template::Javascript::Sort;

use Moo::Role;

around _add_sort => sub {
    my ($orig, $self, $args) = @_;
 
    my $table = $self->$orig($args);
    my $sort_options = $self->sort_options;
    for ( keys %{ $sort_options } ) {
        my $header = $table->get_header($_);
    
        my $sort = $header->add_child({ html_tag => 'i', text => '&#9658;', style => 'float:right;' });
        $sort->onclick(sprintf "%sTc.sortData(this, %s, 'desc')", $self->table_name, $_);
    }
    return $table;
};

no Moo::Role;

1;

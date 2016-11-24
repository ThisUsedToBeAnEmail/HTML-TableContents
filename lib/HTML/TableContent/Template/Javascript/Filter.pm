package HTML::TableContent::Template::Javascript::Filter;

use Moo::Role;

use HTML::TableContent::Element;

around _add_filter => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    my $filter_options = $self->filter_options;
    for ( keys %{ $filter_options } ) {
        my $header = $table->get_header($_);
        my $unique_values = $header->unique_cells;
        my $id = sprintf '%sFilter', $self->table_name;

        my $label = $header->add_child({
            html_tag => 'i',
            text => '&#x02261;', 
            onclick => sprintf "%sTc.toggleFilter('%s')", $self->table_name, $id
        });

        my $filter = $header->add_child({ 
            html_tag => 'select',
            id => $id,
            class => 'form-control input-sg search-hide',
            autocomplete => 'off'
        });

        $filter->onchange(sprintf "%sTc.filter(this.value, %s)", $self->table_name, $header->index);
        $filter->add_child({ html_tag => 'option', value => 'all', text => 'All', selected => 'selected' });

        for ( keys %{ $unique_values } ) {
            $filter->add_child({ html_tag => 'option', value => $_, text => $_ });
        }
    }

    return $table;
};

no Moo::Role;

1;

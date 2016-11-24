package HTML::TableContent::Template::Javascript::Display;

use Moo::Role;

around setup_show => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);

    my $display = $self->display;

    my $para = HTML::TableContent::Element->new({ 
        html_tag => 'p', 
        style => 'float:right;',
    });

    my $select = $para->add_child({ html_tag => 'select', style => 'color:black;', autocomplete => 'off' }); 
    $select->onchange(sprintf "%sTc.setItemsPerPage(this.value)", $self->table_name);
    
    for (@{ $self->display_options }) {
        my $option = $select->add_child({ html_tag => 'option', text => $_, value => $_ });

        if ($_ == $display) {
            $option->selected('selected');
        }
    }

    $para->inner_html(['Display: %s', '_render_element']);

    push @{ $table->after_element }, $para;
    
    return $table;
};

no Moo::Role;

1;

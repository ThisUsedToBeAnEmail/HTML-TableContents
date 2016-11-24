package HTML::TableContent::Template::Javascript::Search;

use Moo::Role;
use HTML::TableContent::Element;

around add_search_box => sub {
    my ($orig, $self, $args) = @_;
    
    my $table = $self->$orig($args);
    
    my $caption = $table->caption;
    
    my $table_name = $self->table_name;
    my $search_box_id = sprintf '%s-input', $table_name;
    my $keyup = sprintf '%sTc.search(this)', $table_name;

    my $search = $caption->add_child({
        html_tag => 'input',
        type => 'text',
        id => $search_box_id,
        onkeyup => $keyup,
        placeholder => $self->search_text
    });

    return $table;
};

no Moo::Role;

1;

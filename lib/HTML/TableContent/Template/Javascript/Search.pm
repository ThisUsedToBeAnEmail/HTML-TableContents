package HTML::TableContent::Template::Javascript::Search;

use Moo::Role;
use HTML::TableContent::Element;

around add_search_box => sub {
    my ($orig, $self, $args) = @_;
    
    my $table = $self->$orig($args);
    my $table_name = $self->table_name;
    my $search_box_id = sprintf '%s-input', $table_name;
    my $keyup = sprintf '%sTc.search(this)', $table_name;

    my $search = HTML::TableContent::Element->new({
        html_tag => 'input',
        type => 'text',
        id => $search_box_id,
        onkeyup => $keyup,
        placeholder => 'Search for Something...'
    });

    push @{ $table->before_element }, $search;

    return $table;
};

no Moo::Role;

1;

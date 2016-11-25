package HTML::TableContent::Template::Javascript::Search;

use Moo::Role;
use HTML::TableContent::Element;

use feature qw/switch/;
no warnings 'experimental'; 

around add_search_box => sub {
    my ($orig, $self, $args) = @_;
    
    my $table = $self->$orig($args);
    my $table_name = $self->table_name;
    my $search_box_id = sprintf '%s-input', $table_name;
    my $keyup = sprintf '%sTc.search(this)', $table_name;
    
    my $search_args = {
        html_tag => 'input',
        type => 'text',
        id => $search_box_id,
        onkeyup => $keyup,
        placeholder => $self->search_text
    };
    
    my $search_box = $self->add_search_box_position($table, $search_args);

    return $table;
};

sub add_search_box_position {
    my $class = 'HTML::TableContent::Element';
    my $args = $_[2];
    given ($_[0]->search_box_position) {
        when (/caption/) {
            my $caption = $_[1]->caption;
            $caption->add_child($args);
        }
        when (/before/) {
            my $search_box = $class->new($args);
            push @{ $_[1]->before_element }, $search_box;
        }
        when (/after/) { 
            my $search_box = $class->new($args);
            push @{ $_[1]->after_element }, $search_box;
        }
    }
    return $_[1];
}

no Moo::Role;

1;

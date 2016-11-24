package HTML::TableContent::Template::Display;

use Moo::Role;
use HTML::TableContent::Element;

has [qw/display display_options/] => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_display {
    my $self = shift;

    my $table_options = $self->table_options;

    return defined $table_options->{display}
        ? $table_options->{display}
        : 10;
}

sub _build_display_options {
    my $self = shift;

    my $table_options = $self->table_options;

    return defined $table_options->{display_option} 
        ? $table_options->{display_option} 
        : [qw/5 10 15 20 25/];
}

sub highest_display {
    my $display_options = $_[0]->display_options;
    my @sorted = sort { $a <=> $b } @{ $display_options };
    return $sorted[0];
}

around last_chance => sub {
    my ($orig, $self, $args) = @_;

    my $table = $self->$orig($args);
    if (defined $self->pagination){
        $table = $self->setup_show($table);
    }   
    return $table 
};

## Could refactor the below into - Table
sub setup_show {
    return $_[1];
}

no Moo::Role;

1;

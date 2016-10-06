package HTML::TableContent::Template::Role;

use strict;
use warnings;
use Moo::Role;

our $VERSION = '0.11';

requires qw/_data/;

has table => (
    is => 'rw',
    builder => '_build_table',
);

sub _build_table {
    my $self = shift;

    my $table = $self->_table;
    
    my $header_spec = $self->_header_spec;
    use Data::Dumper;
    warn Dumper $header_spec;
    my @order = ( );
    for (@{$header_spec}){
        push @order, keys %{ $_ };
    }
    warn Dumper \@order;
    
    $table->sort({ order => \@order });

    my $data = $self->_data;

    foreach my $hash ( @{ $data } ) {
        my $row = $table->add_row({});
        foreach ( $table->all_headers ) {
            my $cell = $row->add_cell({ text => $hash->{$_->text} });
        }
    }

    return $table;
}

sub render {
    return $_[0]->table->render;
}

1;

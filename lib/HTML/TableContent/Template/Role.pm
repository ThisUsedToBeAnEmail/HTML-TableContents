package HTML::TableContent::Template::Role;

use strict;
use warnings;

use Moo::Role;

use HTML::TableContent::Table;

our $VERSION = '0.11';

has table => (
    is => 'rw',
    builder => '_build_table',
    clearer => 1,
);

has data => (
    is => 'rw',
    builder => '_build_data',
);

sub render {
    return $_[0]->table->render;
}

sub _build_data {
    my $self = shift;

    return [ ];
}

sub _build_table {
    my $self = shift;

    my $data = $self->data;

    return unless scalar @{ $data };

    my $table = HTML::TableContent::Table->new({});
  
    my $caption_spec = $self->_caption_spec;

    my $cap = (keys %{ $caption_spec->[0] })[0];
    $table->caption($self->$cap);

    my $header_spec = $self->_header_spec;
  
    for (@{$header_spec}){
        my $attr = (keys %{ $_ })[0];
        push @{ $table->headers }, $self->$attr;
    }

    if ( ref $data->[0] eq "ARRAY" ) {
       my $headers = shift @{ $data };
       my $new = [ ];
       foreach my $row ( @{ $data } ) { 
            my %hash = ( );
            for (0 .. scalar @{ $row } - 1) {
                $hash{$headers->[$_]} = $row->[$_];
            }
            push @{ $new }, \%hash;
       }
       $data = $new;
    }

    foreach my $hash ( @{ $data } ) {
        my $row = $table->add_row({});
        foreach ( $table->all_headers ) {
            my $cell = $row->add_cell({ text => $hash->{$_->template_attr} });
            $table->parse_to_column($cell);
        }
    }

    return $table;
}


1;

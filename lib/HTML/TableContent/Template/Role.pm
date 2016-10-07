package HTML::TableContent::Template::Role;

use strict;
use warnings;

use Moo::Role;

use HTML::TableContent::Table;
use Lingua::EN::Numbers qw(num2en);

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

    my %row_spec = $self->_row_spec;

    my $row_index = 1;
    foreach my $hash ( @{ $data } ) {
        my $row_base = $self->_element_spec($row_index++, %row_spec);
        my $row = $table->add_row($row_base);
        foreach ( $table->all_headers ) {
            my $cell = $row->add_cell({ text => $hash->{$_->template_attr} });
            $table->parse_to_column($cell);
        }
    }

    return $table;
}


sub _element_spec {
    my ( $self, $index, %row_spec) = @_;

    my $row_base = { };

    return $row_base unless keys %row_spec;

    if (my $all = $row_spec{all} ) {
        for ( keys %{ $all } ) {
            $row_base->{$_} = $all->{$_};
        }
    }

    if ( defined $row_spec{odd} && $index % 2 == 1 ) {
        my $odd = $row_spec{odd};
        for ( keys %{ $odd } ) {
            $row_base->{$_} = $odd->{$_};
        }
    }

    if ( defined $row_spec{even} && $index % 2 == 0 ) {
        my $even = $row_spec{even};
        for ( keys %{ $even } ) {
            $row_base->{$_} = $even->{$_};
        }
    }

    my $num = num2en($index);
    if (my $row = $row_spec{$num}) {
        for ( keys %{ $row } ) {
            $row_base->{$_} = $row->{$_};
        }
    }

    return $row_base;
}

1;

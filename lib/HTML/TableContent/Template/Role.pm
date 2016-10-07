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
    my %cell_spec = $self->_cell_spec;

    my $row_index = 1;
    foreach my $hash ( @{ $data } ) {
        my $row_base = $self->_element_spec($row_index, %row_spec);
        my $row = $table->add_row($row_base);

        my $cell_index = 1;
        foreach ( $table->all_headers ) {
            $cell_spec{row_index} = $row_index;
            my $cell_base = $self->_element_spec($cell_index++, %cell_spec);
            $cell_base->{text} = $hash->{$_->template_attr};
            my $cell = $row->add_cell($cell_base);
            $table->parse_to_column($cell);
        }

        $row_index++;
    }

    return $table;
}

sub _element_spec {
    my ( $self, $index, %spec) = @_;

    my $row_base = { };
    my $row_index = delete $spec{row_index};

    return $row_base unless keys %spec;

    if (my $all = delete $spec{all} ) {
        $row_base = $self->_add_to_base($row_base, $all);
    }

    my $odd = delete $spec{odd};
    if ( defined $odd && $index % 2 == 1 ) {
        $row_base = $self->_add_to_base($row_base, $odd);
    }

    my $even = delete $spec{even};
    if ( defined $even && $index % 2 == 0 ) {
        $row_base = $self->_add_to_base($row_base, $even);
    }

    return $row_base unless keys %spec;

    my $num = num2en($index);

    if (defined $row_index) {
        $num = sprintf('%s__%s', num2en($row_index), $num);
    }

    if (my $row = $spec{$num}) {
        $row_base = $self->_add_to_base($row_base, $row);
    } else {
        for (keys %spec) {
            next unless defined $spec{$_}->{index};
            my $safe = $index;
            if ( defined $row_index ) {
                $safe = sprintf('%s__%d', $row_index, $safe);
            }
            
            if ( $spec{$_}->{index} =~ m{$safe}ixms ) {
                $row_base = $self->_add_to_base($row_base, $spec{$_});
            }
        }
    }

    return $row_base;
}

sub _add_to_base {
    my ( $self, $base, $hash ) = @_;

    for ( keys %{ $hash } ) {
        $base->{$_} = $hash->{$_};
    }

    return $base;
}

1;

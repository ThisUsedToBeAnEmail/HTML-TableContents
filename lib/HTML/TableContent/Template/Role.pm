package HTML::TableContent::Template::Role;

use strict;
use warnings;

use Moo::Role;

use HTML::TableContent::Table;
use Lingua::EN::Numbers qw(num2en);
use Data::Dumper;

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
   return $_[0]->can('_data') ? $_[0]->_data : [ ];
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
    my %row_spec = $self->_row_spec;
    my %cell_spec = $self->_cell_spec; 

    for (0 .. scalar @{$header_spec} - 1){
        my $attr = (keys %{ $header_spec->[$_] })[0];
        my $header = $self->$attr;

        if (my $cells = delete $header->attributes->{cells}){
            $cell_spec{$_ + 1} = $cells;
        }

        push @{ $table->headers }, $header;
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

    my $row_index = 1;
    foreach my $hash ( @{ $data } ) {
        my $row_base = $self->_element_spec($row_index, %row_spec);
        
        %cell_spec = $self->_reset_cell_spec($row_base, $row_index, %cell_spec);
        my $row = $table->add_row($row_base);
        my $cell_index = 1;
        foreach ( $table->all_headers ) {
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

    my $base = { };
    my $row_index = delete $spec{row_index};

    return $base unless keys %spec;

    if ( my $col = delete $spec{$index} ) {
        $base = $self->_add_to_base($base, $row_index, $col);        
    }

    if ( my $cells = delete $spec{current}){
        $base = $self->_add_to_base($base, $index, $cells);
    }

    if (my $all = delete $spec{all} ) {
        $base = $self->_add_to_base($base, $index, $all);
    }

    my $odd = delete $spec{odd};
    if ( defined $odd && $index % 2 == 1 ) {
        $base = $self->_add_to_base($base, $index, $odd);
    }

    my $even = delete $spec{even};
    if ( defined $even && $index % 2 == 0 ) {
        $base = $self->_add_to_base($base, $index, $even);
    }

    return $base unless keys %spec;

    my $num = num2en($index);

    if (defined $row_index) {
        $num = sprintf('%s__%s', num2en($row_index), $num);
    }

    if (my $row = delete $spec{$num}) {
        $base = $self->_add_to_base($base, $index, $row);
    } else { 
        for (keys %spec) {
            next unless defined $spec{$_}->{index};
            my $safe = defined $row_index ? sprintf('%s__%d', $row_index, $index) : $index;
            
            if ( $spec{$_}->{index} =~ m{$safe}ixms ) {
                $base = $self->_add_to_base($base, $index, $spec{$_});
            }
        }
    }
    
    return $base;
}

sub _add_to_base {
    my ( $self, $base, $index, $hash ) = @_;

    if ( my $id = $hash->{increment_id} ) {
        $hash->{id} = sprintf('%s%s', $id, $index);
    }

    if ( my $cells = $hash->{cells} ) {
        $base->{cells} = $cells;
    }

    if ( my $cells = $hash->{alternate_classes} ) {
        my $class = shift @{ $cells };
        $base->{class} = $self->_join_class($class, $base->{class});
        push @{ $cells }, $class;
    }

    for ( keys %{ $hash } ) {
        next if $_ =~ m{increment_id}ixms;

        if ( $_ eq 'class' ) {
            $base->{$_} = $self->_join_class($hash->{$_}, $base->{$_});
        }

        $base->{$_} = $hash->{$_};
    }

    return $base;
}

sub _reset_cell_spec {
    my ($self, $row_base, $row_index, %cell_spec) = @_;

     defined $row_base->{cells} ? $cell_spec{current} = delete $row_base->{cells} : delete $cell_spec{current};

    $cell_spec{row_index} = $row_index;

    for (keys %cell_spec) {
        next unless ref $cell_spec{$_} eq 'HASH' && defined $cell_spec{$_}->{oac};
        my @classes = @{ $cell_spec{$_}->{oac} };
        $cell_spec{$_}->{alternate_classes} = \@classes;
    }

    return %cell_spec;
}

sub _join_class {
    my ( $self, $class, $current ) = @_;

    return defined $current ? sprintf('%s %s', $current, $class) : sprintf('%s', $class);
}

1;

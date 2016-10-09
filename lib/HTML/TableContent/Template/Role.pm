package HTML::TableContent::Template::Role;

use strict;
use warnings;

use Moo::Role;
use Carp qw/croak/;

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
    lazy => 1,
    trigger => 1,
);

sub render {
    return $_[0]->table->render;
}

sub _build_data {
   return $_[0]->can('_data') ? $_[0]->_coerce_data($_[0]->_data) : [ ];
}

sub _trigger_data {
    if ( ref $_[1]->[0] eq 'ARRAY' ) {
        return $_[0]->data($_[0]->_coerce_data($_[1]));
    }
    return;
}

sub _coerce_data {
    if ( ref $_[1]->[0] eq "ARRAY" ) {
       my $headers = shift @{ $_[1] };
       my $new = [ ];
       foreach my $row ( @{ $_[1] } ) { 
            my %hash = ( );
            for (0 .. scalar @{ $row } - 1) {
                $hash{$headers->[$_]} = $row->[$_];
            }
            push @{ $new }, \%hash;
       }
       return $new;
    }
    return $_[1];
}

sub _build_table {
    my $self = shift;

    my $data = $self->data;

    return unless scalar @{ $data };

    my $table = HTML::TableContent::Table->new({});
  
    my $caption_spec = $self->_caption_spec;

    my $cap = (keys %{ $caption_spec->[0] })[0];
    my $caption = $table->caption($self->$cap);
    $caption = $self->_set_inner_html('render_caption', $caption);
    
    my $header_spec = $self->_header_spec; 
    my %row_spec = $self->_row_spec;
    my %cell_spec = $self->_cell_spec; 

    for (0 .. scalar @{$header_spec} - 1){
        my $attr = (keys %{ $header_spec->[$_] })[0];
        my $header = $self->$attr;

        if (my $cells = delete $header->attributes->{cells}) {
            $cell_spec{$_ + 1} = $cells;
        }

        $header = $self->_set_inner_html('render_header', $header);
        
        push @{ $table->headers }, $header;
    }

    my $row_index = 1;
    foreach my $hash ( @{ $data } ) {
        my $row_base = $self->_element_spec($row_index, %row_spec);
        
        %cell_spec = $self->_refresh_cell_spec($row_base, $row_index, %cell_spec);
        my $row = $table->add_row($row_base);
        $row = $self->_set_inner_html('render_row', $row);

        my $cell_index = 1;
        foreach ( $table->all_headers ) {
            my $cell_base = $self->_element_spec($cell_index++, %cell_spec);
            $cell_base->{text} = $hash->{$_->template_attr};
            my $cell = $row->add_cell($cell_base);
            $cell = $self->_set_inner_html('render_cell', $cell);
            $table->parse_to_column($cell);
        }

        $row_index++;
    }

    if ( $self->can('last_chance') ) {
        $table = $self->last_chance($table);
    }

    return $table;
}

sub _element_spec {
    my ( $self, $index, %spec) = @_;

    my $base = { };
    my $row_index = delete $spec{row_index};

    return $base unless keys %spec;

    my $num = $self->_num_to_en($index);

    if (defined $row_index) {
        $num = sprintf('%s__%s', $self->_num_to_en($row_index), $num);
    }

    my @pot = ($index, qw/current all odd even/, $num);
    
    for (@pot) {
        if ( my $sp = delete $spec{$_} ) {
            if ( $_ =~ m{odd|even} ) { 
                my $action = sprintf('_add_%s', $_);
                $base = $self->$action($base, $index, $sp);
            } else {
                my $req_index = $_ =~ m{^\d$}xms ? $row_index : $index;
                $base = $self->_add_base($base, $req_index, $sp);
            }
        }
    }

    return $base unless keys %spec;
    
    for (keys %spec) {
        next unless defined $spec{$_}->{index};
        my $safe = defined $row_index ? sprintf('%s__%d', $row_index, $index) : $index;
        
        if ( $spec{$_}->{index} =~ m{$safe}ixms ) {
            $base = $self->_add_to_base($base, $index, $spec{$_});
        }
    }

    return $base;
}

sub _add_base {
    return $_[0]->_add_to_base($_[1], $_[2], $_[3]);
}

sub _add_odd {
    return $_[1] unless $_[2] % 2 == 1;
    return $_[0]->_add_to_base($_[1], $_[2], $_[3]);
}

sub _add_even {
    return $_[1] unless $_[2] % 2 == 0;
    return $_[0]->_add_to_base($_[1], $_[2], $_[3]);
}

sub _add_to_base {
    my ( $self, $base, $index, $hash ) = @_;

    my @pot = (qw/increment_id cells alternate_classes/);
    for (@pot) {
        if ( my $p = $hash->{$_} ) {
            my $action = sprintf('_base_%s', $_);
            $self->$action($p, $base, $index, $hash);
        }
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

sub _base_increment_id {
    return $_[4]->{id} = sprintf('%s%s', $_[1], $_[3]);
}

sub _base_cells {
    return $_[2]->{cells} = $_[1];
}

sub _base_alternate_classes {
    my $class = shift @{ $_[1] };
    $_[2]->{class} = $_[0]->_join_class($class, $_[2]->{class});
    push @{ $_[1] }, $class;
}

sub _refresh_cell_spec {
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

sub _set_inner_html {
    my ($self, $action, $element, $attr) = @_;
 
    $attr ||= $element->attributes;

    if ( my $inner_html = delete $attr->{inner_html}) {
        if ( ref $inner_html eq 'ARRAY' ) {
            $element->inner_html($inner_html);
        } elsif ( $self->can($inner_html) ) {
            $element->inner_html($self->$inner_html);
        } else {
            croak "inner_html on $element->template_attr needs to be either an ArrayRef or A reference to a Sub";
        }
    } elsif ( $self->can($action) ) {
        $element->inner_html($self->$action);
    } 
   
    return $element;
}

has '_small_num_en' => ( 
    is => 'ro',
    lazy => 1,
    default => sub {
        my %NUM = ( );
        @NUM{1 .. 20,30,40,50,60,70,80,90} = qw/
             one two three four five six seven eight nine ten
             eleven twelve thirteen fourteen fifteen
             sixteen seventeen eighteen nineteen
             twenty thirty forty fifty sixty seventy eighty ninety
        /;
        return \%NUM;
   }
);

has '_large_num_en' => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my %NUM = ( );
        @NUM{3 .. 6} = qw/hundred thousand billion trillion/;
        return \%NUM;
    }
);

sub _num_to_en {
    return unless $_[1] =~ m/^\d+$/xms;   

    my $small = $_[0]->_small_num_en;
    my $num = '';
    if ($num = $small->{$_[1]} ){
        return $num;
    }

    my @numbers = split '', $_[1];

    if ( scalar @numbers == 2 ) {
        return sprintf('%s_%s', $small->{$numbers[0] . 0}, $small->{$numbers[1]});
    } else {
        my $count = 0;
        @numbers = reverse(@numbers);
        my $string;
        for (@numbers) {
            my $new = $_;
            
            if ( $new == 0 ) { $count++; next; }

            unless ( $count == 0 ) {
                $new .= sprintf '%s' x $count, map { '0' } 1 .. $count;
            }
            
            unless ($num = $small->{$new}) {
                $num = sprintf('%s_%s', $small->{$_}, $_[0]->_large_num_en->{$count + 1});
            }

            $string = defined $string ? sprintf('%s_%s', $num, $string) : sprintf('%s', $num);
            $count++;
        }
        return $string;
    }
}

1;

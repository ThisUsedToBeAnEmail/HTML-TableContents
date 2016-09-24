package HTML::TableContent::Table;

use Moo;

use HTML::TableContent::Table::Caption;
use HTML::TableContent::Table::Header;
use HTML::TableContent::Table::Row;

our $VERSION = '0.07';

extends 'HTML::TableContent::Element';

has caption => ( is => 'rw', );

has [qw(headers rows)] => (
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
);

sub all_rows { return @{ $_[0]->rows }; }

sub add_caption { 
    my $caption = HTML::TableContent::Table::Caption->new($_[1]);   
    $_[0]->caption($caption);
    return $caption;
}

sub add_header { 
    my $header = HTML::TableContent::Table::Header->new($_[1]);
    push @{ $_[0]->headers }, $header;
    return $header;
}

sub add_row { 
    my $row = HTML::TableContent::Table::Row->new($_[1]);
    push @{ $_[0]->rows }, $row;
    return $row;
}

sub row_count { return scalar @{ $_[0]->rows }; }

sub get_row { return $_[0]->rows->[ $_[1] ]; }

sub get_first_row { return $_[0]->get_row(0); }

sub get_last_row { return $_[0]->get_row( $_[0]->row_count - 1 ); }

sub clear_row { return delete $_[0]->rows->[ $_[1] ] }

sub clear_first_row { return $_[0]->clear_row(0); }

sub clear_last_row { return $_[0]->clear_row($_[0]->row_count - 1); }

sub all_headers { return @{ $_[0]->headers }; }

sub header_count { return scalar @{ $_[0]->headers }; }

sub get_header { return $_[0]->headers->[ $_[1] ]; }

sub get_first_header { return $_[0]->get_header(0); }

sub get_last_header { return $_[0]->get_header($_[0]->header_count - 1); }

around raw => sub {
    my ( $orig, $self ) = ( shift, shift );

    my $table = $self->$orig(@_);

    if ( defined $self->caption ) { $table->{caption} = $self->caption->text }

    $table->{headers} = [];
    foreach my $header ( $self->all_headers ) {
        push @{ $table->{headers} }, $header->raw;
    }

    $table->{rows} = [];
    foreach my $row ( $self->all_rows ) {
        push @{ $table->{rows} }, $row->raw;
    }

    return $table;
};

sub headers_spec {
    my $self = shift;

    my $headers = {};
    map { $headers->{ $_->lc_text }++ } $self->all_headers;
    return $headers;
}

sub header_exists {
    my ( $self, @headers ) = @_;

    my $headers_spec = $self->headers_spec;
    for (@headers) { return 1 if $headers_spec->{ lc $_ } }
    return 0;
}

sub get_col {
    my ( $self, $col ) = @_;

    my %args = ( header => $col );
    return $self->get_header_column(%args);
}

sub get_col_text {
    my ( $self, $col ) = @_;

    my %args = ( header => $col );
    return $self->get_header_column_text(%args);
}

sub get_header_column {
    my ( $self, %args ) = @_;

    my @cells  = ();
    my $column = $args{header};
    foreach my $header ( $self->all_headers ) {
        if ( $header->lc_text =~ m{$column}ixms ) {
            for ( $header->all_cells ) {
                push @cells, $_;
            }
        }
    }

    if ( defined $args{dedupe} ) {
        @cells = $self->_dedupe_object_array_not_losing_order(@cells);
    }

    return \@cells;
}

sub get_header_column_text {
    my ( $self, %args ) = @_;
    my $cells = $self->get_header_column(%args);
    my @cell_text = map { $_->text } @{$cells};
    return \@cell_text;
}

sub has_nested_table_column {
    my $self = shift;
    for my $header ( $self->all_headers ) {
        for ( $header->all_cells ) {
            return 1 if $_->has_nested;
        }
    }
    return 0;
}

sub nested_column_headers {
    my $self = shift;

    my $columns = {};
    for my $header ( $self->all_headers ) {
        my $cell = $header->get_first_cell;
        if ( $cell->has_nested ) {
            $columns->{ $header->lc_text }++;
        }
    }
    return $columns;
}

sub _dedupe_object_array_not_losing_order {
    my ( $self, @items ) = @_;

    # someone could probably do this in one line :)
    my %args;
    my @new_items = ();
    foreach my $item (@items) {
        if ( !defined $args{ $item->text } ) {
            $args{ $item->text }++;
            push @new_items, $item;
        }
    }

    return @new_items;
}

sub _filter_headers {
    my ( $self, @headers ) = @_;

    my $headers = [];
    foreach my $header ( $self->all_headers ) {
        for (@headers) {
            if ( $header->lc_text =~ m/$_/ims ) {
                push @{$headers}, $header;
            }
        }
    }

    $self->headers($headers);

    foreach my $row ( $self->all_rows ) {
        $row->_filter_headers($headers);
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Table - Base class for table's 

=head1 VERSION

Version 0.07

=cut

=head1 SYNOPSIS
    
    use HTML::TableContent;
    my $t = HTML::TableContent->new()->parse($string);

    my $table = $t->get_first_table;
    $table->caption;
    $table->header_count;
    $table->row_count;

    foreach my $header ($table->all_headers) {
        ...
    }

    foreach my $row ($table->all_rows) {
        ...
    }

    my $columns_obj = $table->get_col('Savings');
    my $columns = $table->get_header_column_text(header => 'Savings', dedupe => 1);

=head1 DESCRIPTION

Base class for Table's. 

=head1 SUBROUTINES/METHODS

=head2 raw

Return underlying data structure

    $row->raw

=head2 attributes

HashRef of Table attributes

    $table->attributes

=head2 class

Table tag class if found.

    $table->class;

=head2 id

Table id if found.

    $table->id;

=head2 caption

Table caption if found, see L<HTML::TableContent::Caption>.

    $table->caption;

=head2 headers

Array Ref of L<HTML::TableContent::Header>'s

    $table->headers;

=head2 all_headers

Array of L<HTML::TableContent::Header>'s

    $table->all_headers;

=head2 header_count

Number of headers found in table

    $table->header_count;

=head2 get_header

Get header from table by index.

    $table->get_header($index);

=head2 get_first_header

Get first header in the table.

    $table->get_first_header;

=head2 get_last_header

Get last header in the table.

    $table->get_last_header;

=head2 clear_header

Clear header by array index.

    $table->clear_header($index);

=head2 clear_first_header

Clear first header in table.

    $table->clear_first_header;

=head2 clear_last_header

Clear last header in table.

    $table->clear_last_header;

=head2 headers_spec 

Hash containing headers and their occurence count..

    $table->headers_spec;

=head2 header_exists 

Boolean check to see if passed in headers exist.

    $table->header_exists(qw/Header/);

=head2 get_header_column

Returns an array that contains HTML::TableContent::Table::Row::Cell's which belong to that column.

    $table->get_header_column(header => $string);

Sometimes you may want to dedupe the column that is returned. This is done based on the cell's text value.

    $table->get_header_column(header => 'Email', dedupe => 1)

=head2 get_header_column_text

Return an array of the cell's text.

    $table->get_header_column_text(header => 'Email', dedupe => 1);

=head2 get_col

Shorthand for get_header_column(header => '');

    $table->get_col('Email');

=head2 get_col_text

Shorthand for get_header_column_text(header => '')

    $table->get_col_text('Email');

=head2 rows

Array Ref of L<HTML::TableContent::Row>'s

    $table->rows;

=head2 all_rows

Array of L<HTML::TableContent::Row>'s

    $table->all_rows;

=head2 row_count

Number of rows found in table

    $table->row_count;

=head2 get_row

Get row from table by index.

    $table->get_row($index);

=head2 get_first_row

Get first row in the table.

    $table->get_first_row;

=head2 get_last_row

Get last row in the table.

    $table->get_last_row;

=head2 clear_row

Clear row by index.

    $table->clear_row($index);

=head2 clear_first_row

Clear first row in the table.

    $table->clear_first_row;

=head2 clear_last_row

Clear last row in the table.

    $table->clear_last_row;

=head2 nested

ArrayRef of all nested Tables found within the current table.

    $table->nested

=head2 all_nested

Array of all nested Tables found within the current table.

    $table->all_nested

=head2 has_nested

Boolean check, returns true if the table has nested tables.

    $table->has_nested

=head2 count_nested

Count number of nested tables within current table.

    $table->count_nested

=head2 get_first_nested

Get the first nested table.

    $table->get_first_nested

=head2 get_nested

Get Nested table by index.

    $table->get_nested(1);

=head2 has_nested_table_column 

Boolean Check, returns 1 if a headers cells consists of nested tables.

    $table->has_nested_table_column;

=head2 nested_column_headers

Returns a hash key being the header that contains nested tables the second a count of occurence.

    $table->nested_column_headers;

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 DEPENDENCIES

L<Moo>,
L<HTML::Parser>,

L<HTML::TableContent::Parser>,
L<HTML::TableContent::Table>,
L<HTML::TableContent::Table::Caption>,
L<HTML::TableContent::Table::Header>,
L<HTML::TableContent::Table::Row>,
L<HTML::TableContent::Table::Row::Cell>

=head1 BUGS AND LIMITATIONS

=head1 ACKNOWLEDGEMENTS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

=head1 LICENSE AND COPYRIGHT

Copyright 2016 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut


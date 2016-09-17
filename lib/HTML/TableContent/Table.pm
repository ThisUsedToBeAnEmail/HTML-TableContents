package HTML::TableContent::Table;

use Moo;
use Data::Dumper;

with 'HTML::TableContent::Role::Content';

has caption => (
    is => 'rw',
);

has [ qw(headers rows) ] => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

sub all_rows {
    return @{ shift->rows };
}

sub row_count {
    return scalar @{ shift->rows };
}

sub get_row {
    return shift->rows->[shift];
}

sub get_first_row {
    return shift->get_row(0);
}

sub all_headers {
    return @{ shift->headers };
}

sub header_count {
    return scalar @{ shift->headers };
}

sub get_header {
    return shift->headers->[shift];
}

sub get_first_header {
    return shift->get_header(0);
}

sub header_exists {
    my ($self, @headers) = @_;

    foreach my $header ( $self->all_headers ) {
        return 1 if grep { $header->text =~ /$_/ } @headers;
    }

    return undef;
}

sub _filter_headers {
    my ($self, @headers) = @_;

    my $headers = [ ];
    foreach my $header ( $self->all_headers ) {
        push @{ $headers }, $header 
            if grep { $header->text =~ /$_/ } @headers;
    }

    $self->headers($headers);
    
    foreach my $row ( $self->all_rows ) {
        $row->_filter_headers($headers);
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Table

=head1 VERSION

Version 0.01

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
 
=head1 DESCRIPTION

=head1 METHODS

=head2 attributes

HashRef of Table attributes

    $table->attributes

=head2 class

Table tag class if found, default is undef.

    $table->class;

=head2 id

Table id if found, default is undef.

    $table->id;

=head2 caption

Table caption if found, see HTML::TableContent::Caption.

    $table->caption;

=head2 headers

Array Ref of HTML::TableContent::Header's

    $table->headers;

=head2 all_headers

Array of HTML::TableContent::Header's

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

=head2 rows

Array Ref of HTML::TableContent::Row's

    $table->rows;

=head2 all_rows

Array of HTML::TableContent::Row's

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

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

=head1 SUPPORT

=back

=head1 ACKNOWLEDGEMENTS

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


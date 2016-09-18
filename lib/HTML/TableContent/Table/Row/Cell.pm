package HTML::TableContent::Table::Row::Cell;

use Moo;

our $VERSION = '0.01';

extends 'HTML::TableContent::Element';

has 'header' => ( is => 'rw', );

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Table::Row::Cell

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use HTML::TableContent;
    my $t = HTML::TableContent->new()->parse($string);

    my $cell = $t->get_first_table->get_first_row->get_first_cell;
    
    $cell->data;
    $cell->text;

    $cell->header;

    $cell->attributes;
    $cell->class;
    $cell->id;

=cut

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 METHODS

=head2 raw

Return underlying data structure

    $row->raw

=head2 data

ArrayRef of Text elements

    $cell->data;

=head2 text

data as a string joined with a  ' '

    $cell->text;

=head2 header

Column Header, L<HTML::TableContent::Table::Header>.

    $cell->header;

=head2 attributes

HashRef consiting of the tags attributes

    $cell->attributes;

=head2 class

Cell tag class if found.

    $cell->class;

=head2 id

Cell tag id if found.

    $cell->id;

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

=head1 SUPPORT

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

=head1 DEPENDENCIES

L<Moo>
L<HTML::Parser>

L<HTML::TableContent::Parser>
L<HTML::TableContent::Table>
L<HTML::TableContent::Table::Caption>
L<HTML::TableContent::Table::Header>
L<HTML::TableContent::Table::Row>
L<HTML::TableContent::Table::Row::Cell>



=head1 BUGS AND LIMITATIONS

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

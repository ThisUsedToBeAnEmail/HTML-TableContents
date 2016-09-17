package HTML::TableContent::Store;

use Moo;

has [ qw(current_table current_caption current_row current_header current_cell current_element) ] => (
    is => 'rw',
    lazy => 1,
    clearer => 1,
);

has options => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build_options {
    return {
        table => {
            class => 'Table',
            store => [qw/current_table/],
            push_action => '_push_table',
            clear => [qw/current_table current_row current_cell current_header current_element/],
        },
        th => {
            class => 'Table::Header',
            store => [qw/current_header current_element/],
            push_action => '_push_header',
            clear => [qw/current_row current_cell current_header current_element/],
        },
        tr => {
            class => 'Table::Row',
            store => [qw/current_row current_element/],
            push_action => '_push_row',
            clear => [qw/current_row current_cell current_header current_element/],
        }, 
        td => {
            class => 'Table::Row::Cell',
            store => [qw/current_cell current_element/], 
            push_action => '_push_cell',
            clear => [qw/current_cell current_header current_element/],
        },
        caption => {
            class => 'Table::Caption',
            store => [qw/current_element/],
            push_action => '_push_caption',
            clear => [qw/current_element/]
        }
   }
}

sub current_cell_index {
    my $self = shift;

    return scalar @{ $self->current_row->cells };
}

sub current_cell_header {
    my $self = shift;

    my $cell_index = $self->current_cell_index;
    my $header = $self->current_table->headers->[$cell_index];

    push @{ $header->cells }, $self->current_cell;

    return $header;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Store

=head1 VERSION

Version 0.01

=cut

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


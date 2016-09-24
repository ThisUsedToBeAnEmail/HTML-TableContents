package HTML::TableContent::Element;

use Moo;

our $VERSION = '0.07';

around BUILDARGS => sub {
    my ( $orig, $class, $args ) = @_;

    return $class->$orig( attributes => $args );
};

has attributes => (
    is      => 'rw',
    default => sub { {} }
);

has data => (
    is      => 'rw',
    default => sub { [] }
);

has nested => (
    is      => 'rw',
    default => sub { [] },
);

sub has_nested { return scalar @{ $_[0]->nested } ? 1 : 0; }

sub count_nested { return scalar @{ $_[0]->nested }; }

sub get_first_nested { return $_[0]->nested->[0]; }

sub get_nested { return $_[0]->nested->[ $_[1] ]; }

sub all_nested { return @{ $_[0]->nested }; }

sub text { return join q{ }, @{ $_[0]->data }; }

sub lc_text { my $text = join q{ }, @{ $_[0]->data }; return lc $text; }

sub class { return $_[0]->attributes->{class}; }

sub id { return $_[0]->attributes->{id}; }

sub raw {
    my $args = $_[0]->attributes;
    if ( scalar @{ $_[0]->data } ) {
        $args->{text} = $_[0]->text;
        $args->{data} = $_[0]->data;
    }
    return $args;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Element - attributes, text, data, class, id

=head1 VERSION

Version 0.07

=cut

=head1 SYNOPSIS

    $element->attributes;
    $element->data;

    $element->text;
    $element->class;
    $element->id;

=head1 Description

Base for L<HTML::TableContent::Table>, L<HTML::TableContent::Table::Header>,
L<HTML::TableContent::Table::Row>, L<HTML::TableContent::Table::Row::Cell> 
and L<HTML::TableContent::Table::Caption> 

=cut

=head1 SUBROUTINES/METHODS

=head2 attributes

hash consisting of the html attributes belonding to the current element.

    $element->attributes;

=head2 data

Array of text strings belonging to the current element.

    $element->data;

=head2 text

Join ' ' the elements data

    $element->text;

=head2 class

Element tag's class if found.

    $element->class;

=head2 id

Element tag's id if found.

    $element->id;

=head2 nested

ArrayRef of nested Tables.

    $element->nested

=head2 all_nested

Array of nested Tables.

    $element->all_nested

=head2 has_nested

Boolean check, returns true if the element has nested tables.

    $element->has_nested

=head2 count_nested

Count number of nested tables.

    $element->count_nested

=head2 get_first_nested

Get the first nested table.

    $element->get_first_nested

=head2 get_nested

Get Nested table by index.

    $element->get_nested(1);

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

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

=head1 SUPPORT

=head1 DIAGNOSTICS

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

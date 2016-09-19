package HTML::TableContent::Element;

use Moo;

our $VERSION = '0.06';

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

sub text { return join q{ }, @{ shift->data }; }

sub lc_text { my $text = join q{ }, @{ shift->data }; return lc $text; }

sub class { return shift->attributes->{class}; }

sub id { return shift->attributes->{id}; }

sub raw {
    my $self = shift;

    my $args = $self->attributes;

    if ( scalar @{ $self->data } ) {
        $args->{text} = $self->text;
        $args->{data} = $self->data;
    }

    return $args;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Element - attributes, text, data, class, id

=head1 VERSION

Version 0.06

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

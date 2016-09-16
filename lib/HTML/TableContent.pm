package HTML::TableContent;

use Moo;
extends 'HTML::Parser';

use HTML::TableContent::Store;
use HTML::TableContent::Table;
use HTML::TableContent::Table::Row;
use HTML::TableContent::Table::Header;
use HTML::TableContent::Table::Cell;

=head1 NAME

HTML::TableContent

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.13';

has 'debug_on' => (
    is => 'ro',
    default => 0,
);

has 'store' => (
    is => 'rw',
    default => sub { return HTML::TableContent::Store->new(); },
);

has 'tables' => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

sub start
{
    my ($self, $tag, $attr, $attrseq, $origtext) = @_;

    $tag = lc($tag);

    # Store the incoming details in the current 'object'.
    if ($tag eq 'table') {
        my $table = HTML::TableContent::Table->new($attr);
        push @{$self->tables}, $table;
        $self->store->current_table($table);
    } elsif ($tag eq 'th') {
        my $th = HTML::TableContent::Table::Header->new($attr);
        push @{$self->store->current_table->headers}, $th;
        $self->store->current_header($th);
        $self->store->current_element($th);
    } elsif ($tag eq 'tr') {
        my $tr = HTML::TableContent::Table::Row->new($attr);
        push @{$self->store->current_table->rows}, $tr;
        $self->store->current_row($tr);
        $self->store->current_element($tr);
    } elsif ($tag eq 'td') {
        my $td = HTML::TableContent::Table::Cell->new($attr);
        push @{$self->store->current_row->cells}, $td;
        $self->store->current_cell($td);
        $self->store->current_element($td);
    } elsif ($tag eq 'caption') {
        my $cap = $attr;
        $self->store->current_table->caption($cap);
        $self->store->current_element($cap);
    } else {
        ## Found a non-table related tag. Push it into the currently-defined td
        ## or th (if one exists).
        my $elem = $self->store->current_element;
        if ($elem) {
            $self->debug('TEXT(tag) = ', $origtext) if $self->debug_on;
            my $text = $elem->text . $origtext;
            $elem->data($text);
        }
        
    }
    
    $self->debug($origtext) if $self->debug_on;
}

sub text
{
    my ($self, $text) = @_;
    my $elem = $self->store->current_element;
    if (!$elem) {
        return undef;
    }

    $self->debug('TEXT = ', $text) if $self->debug_on;
    
    my $append_text = $elem->text . $text;
    $elem->text($append_text);
}

sub end
{
    my ($self, $tag, $origtext) = @_;
    $tag = lc($tag);

   if (my @clear = @{ $self->store->clear_tags->{$tag} }){
        for (@clear) { my $clearer = 'clear_' . $_; $self->store->$clearer; }
    }
    else {
        ## Found a non-table related close tag. Push it into the currently-defined
        ## td or th (if one exists).
        my $elem = $self->store->current_element;
        if ($elem) {
            $self->debug('TEXT(tag) = ', $origtext) if $self->debug_on;
            my $text = $elem->text . $origtext;
            $elem->text($text);
        }
    }

    $self->debug($origtext) if $self->debug_on;
}

sub parse
{
    my ($self, $data) = @_;

    # Ensure the following keys exist
    $self->SUPER::parse($data);

    return $self->tables;
}

sub table_count {
    return scalar @{ shift->tables };
}

sub debug
{
    my ($self) = shift;
    my $class = ref($self);
    warn "$class: ", join('', @_), "\n";
}

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-tablecontentparser at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContentParser>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::TableContentParser


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContentParser>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-TableContentParser>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-TableContentParser>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-TableContentParser/>

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

1; # End of HTML::TableContentParser

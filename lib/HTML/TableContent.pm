package HTML::TableContent;

use Moo;
extends 'HTML::Parser';

use HTML::TableContent::Store;
use HTML::TableContent::Table;
use HTML::TableContent::Table::Header;
use HTML::TableContent::Table::Row;
use HTML::TableContent::Table::Row::Cell;
use HTML::TableContent::Table::Caption;

our $VERSION = '0.14';

has store => (
    is => 'rw',
    default => sub { return HTML::TableContent::Store->new(); },
);

has tables => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] }
);

sub all_tables {
    return @{ shift->tables };
}

sub get_table {
    return shift->tables->[shift]; 
}

sub get_first_table {
    return shift->get_table(0);
}

sub table_count {
    return scalar @{ shift->tables };
}


sub headers_exist {
    my ($self, @headers) = @_;

    foreach my $table ( $self->all_tables ) {
        return 1 if $table->header_exists(@headers);
    }

    return 0;
}

sub filter_headers {
    my ($self, @headers) = @_;

    my $tables = [ ];
    foreach my $table ( $self->all_tables ) {
        if ( $table->header_exists(@headers) ) {
            $table->_filter_headers(@headers);  
            push @{ $tables }, $table;
        }
    }

    die "passed headers do not exists in any of the tables - " . join ' ', @headers
        unless scalar @{ $tables };

    $self->tables($tables);    
}

sub parse {
    my ($self, $data) = @_;
    
    $self->SUPER::parse($data);

    return $self->tables;
}

sub parse_file {
    my ($self, $file) = @_;

    $self->SUPER::parse_file($file);

    return $self->tables;
}

sub start {
    my ($self, $tag, $attr, $attrseq, $origtext) = @_;

    $tag = lc($tag);

    if ( my $store_tag = $self->store->options->{$tag} ) {
        my $class = 'HTML::TableContent::' . $store_tag->{class};
        my $table = $class->new($attr);
        for (@{ $store_tag->{store} }) {
            $self->store->$_($table);
        }
    }
}

sub text {
    my ($self, $text) = @_;

    if ( my $elem = $self->store->current_element ) {
       push @{ $elem->data }, $text;
    }
}

sub end {
    my ($self, $tag, $origtext) = @_;
    $tag = lc($tag);

    if ( my $clear = $self->store->options->{$tag} ) {
       my $push_action = $clear->{push_action};
       $self->$push_action;
       for ( @{$clear->{clear}} ) { my $clearer = 'clear_' . $_; $self->store->$clearer; }
   }
}

sub _push_table {
    my $self = shift;
    push @{$self->tables}, $self->store->current_table
        if defined $self->store->current_table;
}

sub _push_header {
    my $self = shift;
    push @{$self->store->current_table->headers}, $self->store->current_header
        if defined $self->store->current_header;
}

sub _push_row {
    my $self = shift;

    push @{$self->store->current_table->rows}, $self->store->current_row 
        if defined $self->store->current_row;
}

sub _push_cell {
    my $self = shift;
    
    $self->store->current_cell->header($self->store->current_cell_header);
    push @{$self->store->current_row->cells}, $self->store->current_cell
        if defined $self->store->current_cell;
}

sub _push_caption {
    my $self = shift;
    $self->store->current_table->caption($self->store->current_element);
}

=head1 NAME

HTML::TableContent

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

    use HTML::TableContent;
    my $t = HTML::TableContent->new();
    $t->parse_file('test.html'); 
   
    foreach my $table ($t->all_tables) {
        ....
    }
 
=head1 DESCRIPTION

This module parses the contents of a table from a string or file containing HTML. Each time a table is encountered, the data gets pushed into an array consisting of HTML::TableContent::Table's. 

=head1 METHODS

=head2 parse

Parse $string as a chunk of html.

    $t->parse($string);

=head2 parse_file

Parse a file that contains html.

    $t->parse_file($string);

=head2 tables

Array Ref consisting of HTML::TableContent::Table's

    $t->tables;

=head2 all_tables

Array consisting of HTML::TableContent::Table's

    $t->all_tables;

=head2 table_count

Count number of tables found/stored.
    
    $t->table_count;

=head2 get_table

Get table by index

    $t->get_table($index);

=head2 get_first_table

Get first table

    $t->get_first_table;

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

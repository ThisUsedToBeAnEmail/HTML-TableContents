package HTML::TableContent;

use Carp;
use Moo;

use HTML::TableContent::Parser;

our $VERSION = '0.01';

has parser => (
    is      => 'rw',
    default => sub { return HTML::TableContent::Parser->new() },
);

has tables => (
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
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

sub filter_tables {
    my ( $self, %args ) = @_;

    my $tables = [];

    my @headers = ();
    if ( defined $args{headers} ) {
        push @headers, @{ $args{headers} };
    }
    elsif ( defined $args{header} ) {
        push @headers, $args{header};
    }

    foreach my $table ( $self->all_tables ) {
        if ( $table->header_exists(@headers) ) {
            $table->_filter_headers(@headers);
            push @{$tables}, $table;
        }
    }

    if ( $args{flex} && !scalar @{$tables} ) {
        carp 'none of the passed headers exist in any of the tables aborting filter - %s',
          join q{ }, @headers;
        return;
    }

    return $self->tables($tables);
}

sub headers_spec {
    my $self = shift;

    my $headers = {};
    for my $table ( $self->all_tables ) {
        for ( $table->all_headers ) { $headers->{ $_->lc_text }++ }
    }

    return $headers;
}

sub headers_exist {
    my ( $self, @headers ) = @_;

    my $header_spec = $self->headers_spec;

    for (@headers) { return 1 if $header_spec->{lc $_} }

    return 0;
}

sub raw {
    my $self = shift;

    my $tables = [];
    foreach my $table ( $self->all_tables ) {
        push @{$tables}, $table->raw;
    }

    return $tables;
}

sub parse {
    my ( $self, $data ) = @_;

    $self->parser->clear_current_tables;
    my $current_tables = $self->parser->parse($data);
    push @{ $self->tables }, @{$current_tables};
    return $current_tables;
}

sub parse_file {
    my ( $self, $file ) = @_;

    $self->parser->clear_current_tables;
    my $current_tables = $self->parser->parse_file($file);
    push @{ $self->tables }, @{$current_tables};
    return $current_tables;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

    use HTML::TableContent;
    my $t = HTML::TableContent->new();
    
    $t->parse_file('test.html'); 
   
    my @cell_ids = ( );
    foreach my $table ($t->all_tables) {
        push @cell_ids, map { $_->id } @{ $table->get_header_column('Email') };
    }

    .....

    $t->parse($html);

    my $first_table = $t->get_first_table;
    my $first_row = $first_table->get_first_row;
    
    foreach my $row ($first_table->all_rows) {
        push @column, $row->cells->[0];
    }

=head1 DESCRIPTION

Extract table content from HTML.

=head1 SUBROUTINES/METHODS

=head2 parse

Parse $string as a chunk of html.

    $t->parse($string);

=head2 parse_file

Parse a file that contains html.

    $t->parse_file($string);

=head2 raw

Return underlying data structure

    $t->raw;    

=head2 tables

Array Ref containing HTML::TableContent::Table's

    $t->tables;

=head2 all_tables

Array containing HTML::TableContent::Table's

    $t->all_tables;

=head2 table_count

Count number of tables found/stored.
    
    $t->table_count;

=head2 get_table

Get table by index.

    $t->get_table($index);

=head2 get_first_table

Get first table.

    $t->get_first_table;

=head2 headers_spec

Hash containing all table headers and there occurance count.

    $t->headers_spec;

=head2 filter_tables

Filter all tables by a list of headers, only one header in the list has to match for the filter to run.

    $t->filter_tables(headers => qw/Name Email/);

Filter all tables for a single column.

    $t->filter_tables(header => 'Name');

Sometimes you want a little more flexibility.. i.e you want to keep your tables if none of the headers exist.

    $t->filter_tables(headers => qw/Name Email/, flex => 1);

=head2 headers_exist

Pass an Array of headers if one of the headers match the truth is returned.

    $t->headers_exist(qw/Name Email/);

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

=head1 DEPENDENCIES

=head1 BUGS AND LIMITATIONS

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


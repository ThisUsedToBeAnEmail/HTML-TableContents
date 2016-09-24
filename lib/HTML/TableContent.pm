package HTML::TableContent;

use Carp;
use Moo;

use HTML::TableContent::Parser;
use HTML::TableContent::Table;

our $VERSION = '0.08';

has parser => (
    is      => 'rw',
    lazy => 1,
    default => sub { return HTML::TableContent::Parser->new() },
);

has tables => (
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
);

sub all_tables { return @{ $_[0]->tables }; }

sub add_table {
    my $table = HTML::TableContent::Table->new($_[1]);
    push @{ $_[0]->tables }, $table;
    return $table;
}

sub add_caption_selectors { return push @{ $_[0]->parser->caption_selectors }, $_[1]; }

sub get_table { return $_[0]->tables->[ $_[1] ]; }

sub get_first_table { return $_[0]->get_table(0); }

sub get_last_table { return $_[0]->get_table($_[0]->table_count - 1); }

sub clear_table { return splice @{ $_[0]->tables }, $_[1], 1; }

sub clear_first_table { return shift @{ $_[0]->tables }; }

sub clear_last_table { return $_[0]->clear_table( $_[0]->table_count - 1 ); } 

sub table_count { return scalar @{ $_[0]->tables }; }

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

    for (@headers) { return 1 if $header_spec->{ lc $_ } }

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

    $data =~ s/\<\!--|--\!\>//g;
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

HTML::TableContent - Extract content from HTML tables.

=head1 VERSION

Version 0.08 

=cut

=head1 SYNOPSIS

    use HTML::TableContent;
    my $t = HTML::TableContent->new();
    
    $t->parse_file('test.html'); 
   
    my @cell_ids = ( );
    foreach my $table ($t->all_tables) {
        push @cell_ids, map { $_->id } @{ $table->get_col('Email') };
    }

    .....

    $t->parse($html);

    my $first_table = $t->get_first_table;
    my $first_row = $first_table->get_first_row;
    
    foreach my $row ($first_table->all_rows) {
        push @column, $row->cells->[0];
    }

=head1 DESCRIPTION

Extract content from HTML tables.

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

Array Ref containing L<HTML::TableContent::Table>'s

    $t->tables;

=head2 all_tables

Array containing L<HTML::TableContent::Table>'s

    $t->all_tables;

=head2 add_table

Add a new L<HTML::TableContent::Table>.

    $t->add_table({ id => 'my-first-table', class => 'something' });

=head2 table_count

Count number of tables found/stored.
    
    $t->table_count;

=head2 get_table

Get table by index.

    $t->get_table($index);

=head2 get_first_table

Get first table.

    $t->get_first_table;

=head2 get_last_table

Get last table.

    $t->get_last_table;

=head2 clear_table

Clear table by array index.

    $t->clear_table($index);

=head2 clear_first_table

Clear first table

    $t->clear_first_table;

=head2 clear_last_table

Clear last table.

    $t->clear_last_table;

=head2 headers_spec

Hash containing all table headers and their occurrence count.

    $t->headers_spec;

=head2 filter_tables

Filter all tables by a list of headers, only one header in the list has to match for the filter to run.

    $t->filter_tables(headers => qw/Name Email/);

Filter all tables for a single column.

    $t->filter_tables(header => 'Name');

Sometimes you want a little more flexibility.. i.e you want to keep your tables if none of the headers exist.

    $t->filter_tables(headers => qw/Name Email/, flex => 1);

=head2 headers_exist

Pass an Array of headers, if one of the headers match the truth is returned.

    $t->headers_exist(qw/Name Email/);

=head2 add_caption_selectors

The majority of people don't use captions, but a title above the table.

This method accepts an array of 'tags', 'ids' or 'classes' and will try to do something
sensible which generally means mapping the text to the selector it finds closest to the table. 

    my $t = HTML::TableContent->new();

    $t->add_caption_selectors(qw/id-1 id-2 id-3/);

    $t->parse($html);

=head2 EXAMPLES

LWP::UserAgent

    use HTML::TableContent;
    use LWP::UserAgent;

    my $url = 'https://developers.facebook.com/docs/graph-api/reference/user/';

    my $html = make_request($url);

    my $tc = HTML::TableContent->new();

    $tc->add_caption_selectors(qw/h3/);

    $tc->parse($html);

    $tc->get_first_table->caption->text;  

    sub make_request {
        my $url = shift;

        my ua = LWP::UserAgent->new(
            ssl_opts => { verify_hostname => 1 },
            agent => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.5) Gecko/20060719 Firefox/1.5.0.5'
        );
        my $req = HTTP::Request->new(GET => $url);
        my $reponse = $ua->request($req);

        if ( $response->is_success ) {
            return $response->decoded_content;
        } else {
            .....
        }
    }

Text::CSV_XS

    use HTML::TableContent;
    use Text::CSV_XS qw( csv );

    my $aoa = csv ( in => 'test.csv' );

    my $tc = HTML::TableContent->new();
    
    my $table = $tc->add_table({ id => '1-row' });

    my $headers = shift $aoa->[0];

    foreach my $header ( @{ $headers } ) {
        $table->add_header({ text => $header });
    }

    foreach my $csv_row ( @{ $aoa } ) {
        my $row = $table->add_row({});
        for (@{$csv_row}){
            my $cell = $row->add_cell({ text => $_ });
            $table->parse_to_column($cell);
        }
    }

    $table->render;

=head1 AUTHOR

Robert Acock, C<< <thisusedtobeanemail at gmail.com> >>

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

Please report any bugs or feature requests to C<bug-html-tablecontentparser at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContent>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::TableContent

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContent>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-TableContent>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-TableContent>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-TableContent/>

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

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


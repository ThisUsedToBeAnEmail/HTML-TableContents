# NAME

HTML::TableContent - Extract content from HTML tables.

# VERSION

Version 0.06 

# SYNOPSIS

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

# DESCRIPTION

This module extracts all tables from a html document/string. It parses the data found into a set of objects
that gives you a simple interface to query and access the exact data you desire.

# SUBROUTINES/METHODS

## parse

Parse $string as a chunk of html.

    $t->parse($string);

## parse\_file

Parse a file that contains html.

    $t->parse_file($string);

## raw

Return underlying data structure

    $t->raw;   

## tables

Array Ref containing [HTML::TableContent::Table](https://metacpan.org/pod/HTML::TableContent::Table)'s

    $t->tables;

## all\_tables

Array containing [HTML::TableContent::Table](https://metacpan.org/pod/HTML::TableContent::Table)'s

    $t->all_tables;

## table\_count

Count number of tables found/stored.

    $t->table_count;

## get\_table

Get table by index.

    $t->get_table($index);

## get\_first\_table

Get first table.

    $t->get_first_table;

## headers\_spec

Hash containing all table headers and their occurance count.

    $t->headers_spec;

## filter\_tables

Filter all tables by a list of headers, only one header in the list has to match for the filter to run.

    $t->filter_tables(headers => qw/Name Email/);

Filter all tables for a single column.

    $t->filter_tables(header => 'Name');

Sometimes you want a little more flexibility.. i.e you want to keep your tables if none of the headers exist.

    $t->filter_tables(headers => qw/Name Email/, flex => 1);

## headers\_exist

Pass an Array of headers, if one of the headers match the truth is returned.

    $t->headers_exist(qw/Name Email/);

# AUTHOR

Robert Acock, `<thisusedtobeanemail at gmail.com>`

# DEPENDENCIES

[Moo](https://metacpan.org/pod/Moo),
[HTML::Parser](https://metacpan.org/pod/HTML::Parser),

[HTML::TableContent::Parser](https://metacpan.org/pod/HTML::TableContent::Parser),
[HTML::TableContent::Table](https://metacpan.org/pod/HTML::TableContent::Table),
[HTML::TableContent::Table::Caption](https://metacpan.org/pod/HTML::TableContent::Table::Caption),
[HTML::TableContent::Table::Header](https://metacpan.org/pod/HTML::TableContent::Table::Header),
[HTML::TableContent::Table::Row](https://metacpan.org/pod/HTML::TableContent::Table::Row),
[HTML::TableContent::Table::Row::Cell](https://metacpan.org/pod/HTML::TableContent::Table::Row::Cell)

# BUGS AND LIMITATIONS

Please report any bugs or feature requests to `bug-html-tablecontentparser at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContent](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContent).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::TableContent

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContent](http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContent)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/HTML-TableContent](http://annocpan.org/dist/HTML-TableContent)

- CPAN Ratings

    [http://cpanratings.perl.org/d/HTML-TableContent](http://cpanratings.perl.org/d/HTML-TableContent)

- Search CPAN

    [http://search.cpan.org/dist/HTML-TableContent/](http://search.cpan.org/dist/HTML-TableContent/)

# DIAGNOSTICS

# CONFIGURATION AND ENVIRONMENT 

# INCOMPATIBILITIES

# ACKNOWLEDGEMENTS

# LICENSE AND COPYRIGHT

Copyright 2016 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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

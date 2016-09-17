# NAME

HTML::TableContent

# VERSION

Version 0.01

# SYNOPSIS

       use HTML::TableContent;
       my $t = HTML::TableContent->new();
       $t->parse_file('test.html'); 
      
       foreach my $table ($t->all_tables) {
           ....
       }
    

# DESCRIPTION

This module parses the contents of a table from a string or file containing HTML. Each time a table is encountered, the data gets pushed into an array consisting of HTML::TableContent::Table's. 

# METHODS

## parse

Parse $string as a chunk of html.

    $t->parse($string);

## parse\_file

Parse a file that contains html.

    $t->parse_file($string);

## tables

Array Ref consisting of HTML::TableContent::Table's

    $t->tables;

## all\_tables

Array consisting of HTML::TableContent::Table's

    $t->all_tables;

## table\_count

Count number of tables found/stored.

    $t->table_count;

# AUTHOR

LNATION, `<thisusedtobeanemail at gmail.com>`

# BUGS

Please report any bugs or feature requests to `bug-html-tablecontentparser at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContentParser](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-TableContentParser).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::TableContentParser

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContentParser](http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-TableContentParser)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/HTML-TableContentParser](http://annocpan.org/dist/HTML-TableContentParser)

- CPAN Ratings

    [http://cpanratings.perl.org/d/HTML-TableContentParser](http://cpanratings.perl.org/d/HTML-TableContentParser)

- Search CPAN

    [http://search.cpan.org/dist/HTML-TableContentParser/](http://search.cpan.org/dist/HTML-TableContentParser/)

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

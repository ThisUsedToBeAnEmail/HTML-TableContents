#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableContent;
use Data::Dumper;

my $t = HTML::TableContent->new();
$t->parse_file("t/html/page-two-tables.html");

foreach my $table ($t->all_tables) {
    warn Dumper $table->rows;
}


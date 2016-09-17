#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableContent;
use Data::Dumper;

my $t = HTML::TableContent->new();
$t->parse_file("t/html/catch.html");

warn Dumper $t->get_first_table->get_first_header->cells;



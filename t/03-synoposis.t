#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableContent;
use Data::Dumper;

my $t = HTML::TableContent->new();
$t->parse_file("t/html/catch.html");

$t->filter_headers(qw/this/);

warn Dumper $t->tables;

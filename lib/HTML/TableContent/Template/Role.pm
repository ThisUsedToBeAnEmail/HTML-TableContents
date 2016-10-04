package HTML::TableContent::Template::Role;

use strict;
use warnings;
use Moo::Role;

our $VERSION = '0.11';

requires qw/_headers_data/;

sub process {
    my $self = shift;

    my %header_data = $self->_headers_data;
    return \%header_data;
}

1;

package HTML::TableContent::Template::Role;

use strict;
use warnings;
use Moo::Role;

our $VERSION = '0.11';

requires qw/_header_data _data/;

sub process {
    my $self = shift;

    my $data = $self->_data;

    return $data;
}

1;

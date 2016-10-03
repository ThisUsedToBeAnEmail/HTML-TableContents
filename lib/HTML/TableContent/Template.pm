package HTML::TableContent::Template;

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.11';

my @HEADERS_ATTRIBUTES = qw/text id class/;

sub import {
    my ( undef, @import ) = @_;

    my $target = caller;
   
    for my $needed_method (qw/with around has/) {
        next if $target->can($needed_method);
        croak "Can't find method <$needed_method> in <$target>";
    }

    my $with = $target->can('with');
    my $around = $target->can('around');
    my $has = $target->can('has');

    my @target_isa;
    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    my $headers_data = {};

    my $apply_modifiers = sub {
        return if $target->can('new_with_headers');
        $with->('HTML::TableContent::Template::Role');
    };

    my $option = sub {
        my ( $name, %attributes ) = @_;

        $has->( $name => _filter_attributes(%attributes) );

        $headers_data->{$name}
            = { _validate_and_filter_headers(%attributes) };

        $apply_modifiers->();
        return;
    };

    { no strict 'refs'; *{"${target}::header"} = $option; }

    $apply_modifiers->();

    return; 
}

sub _filter_attributes {
    my %attributes = @_;
    my %filter_key = map { $_ => 1 } @HEADERS_ATTRIBUTES;
    return map { ( $_ => $attributes{$_} ) }
        grep { !exists $filter_key{$_} } keys %attributes;
}

sub _validate_and_filter_headers {
    my (%headers) = @_;

    return %headers;
}

1;
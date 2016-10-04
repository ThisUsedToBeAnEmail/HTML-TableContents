package HTML::TableContent::Template;

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.11';

my @VALID_ATTRIBUTES = qw/is default text id class rowspan style colspan increment_id alternate_class/;

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

    if (@target_isa) {    #only in the main class, not a role
        eval '{
        package ' . $target . ';
        
            sub _headers_data {
                my ( $class, @meta ) = @_;
                return $class->maybe::next::method(@meta);
            }

        1;
        }';
    }

    my $headers_data = {};

    my $apply_modifiers = sub {
        return if $target->can('new_with_headers');
        $with->('HTML::TableContent::Template::Role');
    };

    my $option = sub {
        my ( $name, %attributes ) = @_;

        $has->( $name => _filter_attributes(%attributes) );

        $headers_data->{$name} = { _validate_and_filter_headers(%attributes) };

        $apply_modifiers->();

        $around->(
            _headers_data => sub {
                my ( $orig, $self ) = ( shift, shift );
                return $self->$orig(@_), %$headers_data;
            }
        );

        return;
    };

    { no strict 'refs'; *{"${target}::header"} = $option; }

    $apply_modifiers->();

    return; 
}

sub _filter_attributes {
    my %attributes = @_;
    $attributes{is} = 'ro';

    if (exists $attributes{text}) {
        $attributes{default} = $attributes{text};
    }

    my %filter_key = map { $_ => 1 } @VALID_ATTRIBUTES;

    return map { ( $_ => $attributes{$_} ) }
        grep { exists $filter_key{$_} } keys %attributes;
}

sub _validate_and_filter_headers {
    my (%headers) = @_;

    return %headers;
}

1;

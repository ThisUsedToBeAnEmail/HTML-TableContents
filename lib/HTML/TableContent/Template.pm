package HTML::TableContent::Template;

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.11';

my @VALID_ATTRIBUTES = qw/is default text id class rowspan style colspan increment_id alternate_class/;

my @TABLE = qw/caption header/;

sub import {
    my ( $self, @import ) = @_;

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

            sub _caption_data {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }

            sub _header_data {
                my ( $class, @meta ) = @_;
                return $class->maybe::next::method(@meta);
            }

            sub _data {
                my ($class, @meta ) = @_;
                
                my $data = $class->data;
                return $data if scalar @{ $data };
                die "must supply data";
            }
        1;
        }';
    }

    my $apply_modifiers = sub {
        return if $target->can('new_with_headers');
        $with->('HTML::TableContent::Template::Role');
    };

    for my $element (@TABLE) {
        my $element_data = {};
        my $option = sub {
            my ( $name, %attributes ) = @_;

            my %filtered_attributes = _filter_attributes(%attributes);

            $has->( $name => %filtered_attributes );

            $element_data->{$name} = \%filtered_attributes;

            my $data = sprintf('_%s_data', $element);
            $around->(
                $data => sub {
                    my ( $orig, $self ) = ( shift, shift );
                    return $self->$orig(@_), %$element_data;
                }
            );
    
            return;
        };

        { no strict 'refs'; *{"${target}::$element"} = $option; }
    }

    $apply_modifiers->();

    return; 
}

sub _filter_attributes {
    my (%attributes) = @_;

    $attributes{is} = 'ro';

    my %filter_key = map { $_ => 1 } @VALID_ATTRIBUTES;
    return map { $_ => $attributes{$_} } grep { exists $filter_key{$_} } keys %attributes;
}

1;

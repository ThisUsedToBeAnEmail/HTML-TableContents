package HTML::TableContent::Template;

use strict;
use warnings;
use Carp qw/croak/;
use HTML::TableContent::Table;
use Role::Tiny qw/does_role/;

our $VERSION = '0.11';

my @VALID_ATTRIBUTES = qw/is default text id class rowspan style colspan increment_id alternate_class lazy/;

my @TABLE = qw/caption header row/;

sub import {
    my ( $self, @import ) = @_;
    
    my $target = caller;
    my $table = HTML::TableContent::Table->new({});

    for my $needed_method (qw/with around has/) {
        next if $target->can($needed_method);
        croak "Can't find method <$needed_method> in <$target>";
    }

    my $with = $target->can('with');
    my $around = $target->can('around');
    my $has = $target->can('has');

    my @target_isa;

    return if $target->can('_table');

    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    if (@target_isa) {    #only in the main class, not a role
        eval '{
        package ' . $target . ';

            sub _caption_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }

            sub _header_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }
            
            sub _row_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }

        1;
        }';
    }

    my $apply_modifiers = sub {
        $with->('HTML::TableContent::Template::Role');
    };

    for my $element (@TABLE) {
        my @element = ();
        my $option = sub {
            my ( $name, %attributes ) = @_;
            
            my %filtered_attributes = _filter_attributes($name, $element, $table, %attributes);

            $has->( $name => %filtered_attributes );

            delete $filtered_attributes{default};

            my $element_data->{$name} = \%filtered_attributes;
           
            my $spec = sprintf('_%s_spec', $element);
            
            if ( $element eq 'row' ) {
                $around->(
                    $spec => sub {
                        my ( $orig, $self ) = ( shift, shift );
                        return $self->$orig(@_), %$element_data;
                    }
                );
            } else {
                push @element, $element_data;
                $around->(
                    $spec => sub {
                        my ( $orig, $self ) = ( shift, shift );
                        return $self->$orig(@_), \@element;
                    }
                );
            }
            return;
        };

        { no strict 'refs'; *{"${target}::$element"} = $option; }
    }

    $apply_modifiers->();

    return; 
}

sub _filter_attributes {
    my ($name, $element, $table, %attributes) = @_;

    $attributes{template_attr} = $name;

    if ( ! exists $attributes{text} ) {
        $attributes{text} = $name;
    }

    my %tattr = %attributes;

    $attributes{is} = 'ro';
    $attributes{lazy} = 1;
    my $default_action = sprintf('add_%s', $element);

    if ( $element eq 'row' ) {
        $attributes{default} = sub { return \%tattr; };
    } else {
        $attributes{default} = sub { my %dirt = %tattr; return $table->$default_action(\%dirt); };
    }
    my %filter_key = map { $_ => 1 } @VALID_ATTRIBUTES;
    return map { $_ => $attributes{$_} } grep { exists $filter_key{$_} } keys %attributes;
}

1;

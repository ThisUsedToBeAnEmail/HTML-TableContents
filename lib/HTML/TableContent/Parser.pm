package HTML::TableContent::Parser;

use Moo;

our $VERSION = '0.07';

extends 'HTML::Parser';

use HTML::TableContent::Table;
use HTML::TableContent::Table::Header;
use HTML::TableContent::Table::Row;
use HTML::TableContent::Table::Row::Cell;
use HTML::TableContent::Table::Caption;

has [qw(current_tables nested)] => (
    is      => 'rw',
    lazy    => 1,
    clearer => 1,
    default => sub { [] },
);

has [qw(current_table current_element)] => (
    is      => 'rw',
    lazy    => 1,
    clearer => 1,
);

has options => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub count_nested { return scalar @{ $_[0]->nested }; }

sub has_nested { return $_[0]->count_nested ? 1 : 0; }

sub get_last_nested { return $_[0]->nested->[ $_[0]->count_nested - 1 ]; }

sub clear_last_nested {
    return delete $_[0]->nested->[ $_[0]->count_nested - 1 ];
}

sub all_current_tables { return @{ $_[0]->current_tables }; }

sub count_current_tables { return scalar @{ $_[0]->current_tables }; }

sub current_or_nested {
    return $_[0]->has_nested ? $_[0]->get_last_nested : $_[0]->current_table;
}

sub current_cell_header {
    my ( $self, $current_cell ) = @_;

    my $table = $self->current_or_nested;
    my $row   = $table->get_last_row;

    my $header;
    if ( $row->header ) {
        $header = $row->header;
    }
    else {
        my $cell_index = $table->get_last_row->cell_count;
        $header = $table->headers->[$cell_index];
    }

    return unless $header;

    push @{ $header->cells }, $current_cell;

    return $header;
}

sub parse {
    my ( $self, $data ) = @_;

    $self->SUPER::parse($data);

    return $self->current_tables;
}

sub parse_file {
    my ( $self, $file ) = @_;

    $self->SUPER::parse_file($file);

    return $self->current_tables;
}

sub start {
    my ( $self, $tag, $attr, $attrseq, $origtext ) = @_;

    $tag = lc $tag;

    if ( my $store_tag = $self->options->{$tag} ) {
        my $class   = $store_tag->{class};
        my $element = $class->new($attr);

        $self->current_element($element);

        my $table = $self->current_or_nested;

        if ( $tag eq 'th' ) {
            $table->get_last_row->header($element);
            push @{ $table->headers }, $element;
        }
        if ( $tag eq 'tr' ) {
            push @{ $table->rows }, $element;
        }
        if ( $tag eq 'td' ) {
            $element->header( $self->current_cell_header($element) );
            push @{ $table->get_last_row->cells }, $element;
        }

        if ( $tag eq 'caption' ) {
            $table->caption($element);
        }

        if ( $tag eq 'table' ) {
            if ( defined $self->current_table
                && $self->current_table->isa('HTML::TableContent::Table') )
            {
                if ( $self->has_nested ) {

              # first table has all nested tables - $tp->get_first_table->nested
                    push @{ $self->current_table->nested }, $element;
                }
                push @{ $self->nested },  $element;
                push @{ $table->nested }, $element;
                push @{ $table->get_last_row->get_last_cell->nested }, $element;
            }
            else {
                $self->current_table($element);
            }
        }
    }

    return;
}

sub text {
    my ( $self, $text ) = @_;

    if ( my $elem = $self->current_element ) {
        if ( $text =~ m{\S+}xms ) {
            $text =~ s{^\s+|\s+$}{}g;
            push @{ $elem->data }, $text;
        }
    }

    return;
}

sub end {
    my ( $self, $tag, $origtext ) = @_;

    $tag = lc $tag;

    if ( $tag eq 'table' ) {
        if ( $self->has_nested ) {
            $self->clear_last_nested;
        }
        else {
            push @{ $self->current_tables }, $self->current_table;
            $self->clear_current_table;
        }
    }

    if ( $tag eq 'tr' ) {
        my $table =
          $self->has_nested ? $self->get_last_nested : $self->current_table;

        my $row = $table->get_last_row;

        if ( $row->cell_count == 0 ) {
            $table->clear_last_row;
        }

        if ( $row->header ) {
            $table->clear_last_row;

            my $index = 0;
            foreach my $cell ( $row->all_cells ) {
                my $row = $table->rows->[$index];
                if ( defined $row ) {
                    push @{ $row->cells }, $cell;
                }
                else {
                    my $new_row = HTML::TableContent::Table::Row->new();
                    push @{ $new_row->cells }, $cell;
                    push @{ $table->rows },    $new_row;
                }
                $index++;
            }
        }
    }
}

sub _build_options {
    return {
        table => {
            class => 'HTML::TableContent::Table',
        },
        th => {
            class => 'HTML::TableContent::Table::Header',
        },
        tr => {
            class => 'HTML::TableContent::Table::Row',
        },
        td => {
            class => 'HTML::TableContent::Table::Row::Cell',
        },
        caption => {
            class => 'HTML::TableContent::Table::Caption',
        }
    };
}

1;

__END__

=head1 NAME

HTML::TableContent::Parser - HTML::Parser subclass.

=head1 VERSION

Version 0.07

=cut

=head1 SYNOPSIS

    my $t = HTML::TableContent->new();

    $t->parser->parse($html);

    # most recently parsed tables
    my $last_parsed = $t->parser->current_tables;

    for my $table ( @{ $last_parsed } ) {
        ...
    }

=head1 DESCRIPTION

HTML::Parser subclass.

=head1 SUBROUTINES/METHODS

=head2 parse

Parse $string as a chunk of html.

    $parser->parse($string);

=head2 parse_file

Parse a file that contains html.

    $parser->parse_file($string);

=head2 current_tables

ArrayRef consisiting of the last parsed tables.

    $parser->current_tables;

=head2 all_current_tables

Array consisiting of the last parsed tables.

    $parser->all_current_tables;

=head2 count_current_tables

Count of the current tables.

    $parser->count_current_tables;

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 DEPENDENCIES

L<Moo>,
L<HTML::Parser>, 
L<HTML::TableContent::Parser>,
L<HTML::TableContent::Table>,
L<HTML::TableContent::Table::Caption>, 
L<HTML::TableContent::Table::Header>,
L<HTML::TableContent::Table::Row>,
L<HTML::TableContent::Table::Row::Cell>

=head1 CONFIGURATION AND ENVIRONMENT 

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 SUPPORT

=head1 DIAGNOSTICS

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2016 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

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

=cut


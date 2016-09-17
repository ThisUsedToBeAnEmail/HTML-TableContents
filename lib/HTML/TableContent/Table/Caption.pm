package HTML::TableContent::Table::Caption;

use Moo;

with 'HTML::TableContent::Role::Content';

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::TableContent::Table::Caption

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use HTML::TableContent;
    my $t = HTML::TableContent->new()->parse($string);

    my $caption = $t->get_first_table->caption;
    
    $caption->data;
    $caption->text;

    $caption->attributes;
    $caption->class;
    $caption->id;

=cut

=head1 DESCRIPTION

=head1 METHODS

=head2 data

ArrayRef of Text elements

    $caption->data;

=head2 text

data as a string joined with a  ' '

    $caption->text;

=head2 attributes

HashRef consiting of the tags attributes

    $caption->attributes;

=head2 class

Caption tag class if found.

    $caption->class;

=head2 id

Caption tag id if found.

    $caption->id;

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

=head1 SUPPORT

=back

=head1 ACKNOWLEDGEMENTS



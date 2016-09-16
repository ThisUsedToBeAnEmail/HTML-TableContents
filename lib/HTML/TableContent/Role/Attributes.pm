package HTML::TableContent::Role::Attributes;

use Moo::Role;

around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;

    return $class->$orig(attributes => $args);
};

has 'attributes' => (
    is => 'rw',
    default => sub { { } }
);

has 'text' => (
    is => 'rw',   
    lazy => 1
);

sub class { shift->attributes->{class}; }

sub id { shift->attributes->{id}; }

no Moo::Role;

1;

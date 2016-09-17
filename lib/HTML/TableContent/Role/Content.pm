package HTML::TableContent::Role::Content;

use Moo::Role;

around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;

    return $class->$orig(attributes => $args);
};

has attributes => (
    is => 'rw',
    default => sub { { } }
);

has data => (
    is => 'rw',   
    lazy => 1,
    default => sub { [ ] }
);

sub text { join ' ', @{ shift->data }; }

sub class { shift->attributes->{class}; }

sub id { shift->attributes->{id}; }

no Moo::Role;

1;
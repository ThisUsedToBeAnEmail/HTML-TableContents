package HTML::TableContent::Template::Javascript;

use Moo::Role;

has js_name => (
    is => 'rw',
    lazy => 1,
);

has 'header_js' => (
    is => 'ro',
    default => sub { [ ] },
);

sub render_header_js {
    my $js = join "\n", @{ $_[0]->header_js };
    return sprintf '<script type="text/javascript">%s</script>', $js;
}

1;

package HTML::TableContent::Template::DBIC;

use Moo::Role;

has rs => (
    is => 'ro',
    lazy => 1,
);

has result => (
    is => 'ro',
    lazy => 1,
);

sub add_template_rows {
    my ($self, $table, %row_spec, %cell_spec) = @_;

    if ( defined $self->rs ) {
        $table = $self->_rows_from_rs($table, %row_spec, %cell_spec);
    } elsif ( my $result = $self->result ) {
        my $row = $self->_row_from_result(1, $result, $table, %row_spec, %cell_spec); 
    } else {
        die 'You must supply either a result or resultset';
    }

   return $table;
}

sub _rows_from_rs {
    my ($self, $table, %row_spec, %cell_spec) = @_;

    my $row_index = 1;
    foreach my $result ( $self->rs->all ) {
        my $row = $self->_row_from_result($row_index, $result, $table, %row_spec, %cell_spec);
        $row_index++;
    }
    return $table;
}

sub _row_from_result {
    my ($self, $row_index, $result, $table, %row_spec, %cell_spec) = @_;
    
    my $row_base = $self->_element_spec($row_index, %row_spec);
        
    %cell_spec = $self->_refresh_cell_spec($row_base, $row_index, %cell_spec);
    my $row = $table->add_row($row_base);

    my $cell_index = 1;
    foreach ( $table->all_headers ) {
        my $cell_base = $self->_element_spec($cell_index++, %cell_spec);
        my $field = $_->template_attr;
        
        if (my $relationship = $_->attributes->{relationship}) {
            my $rel = $result->$relationship;
            if ( $field = $_->attributes->{field}) {
                $cell_base->{text} = $rel->$field;    
            } else {
                die "You need to define a field for $field - $relationship";
            }
        } else {
            $cell_base->{text} = $result->$field;
        }

        my $cell = $row->add_cell($cell_base);
        $cell = $self->_set_html($cell);
        $table->parse_to_column($cell);
    }

    $row = $self->_set_html($row);

    return $row;
}

1;


use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('HTML::TableContent');
}

use Text::CSV_XS qw( csv );
use Data::Dumper;

my $aoa = csv ( in => 't/csv/1-row.csv');

my $tc = HTML::TableContent->new();

my $table = $tc->add_table({ id => '1-row' });

my $headers = delete $aoa->[0];

foreach my $header ( @{ $headers }) {
    $table->add_header({ text => $header });
}

foreach my $csv_row ( @{ $aoa } ) {
    my $row = $table->add_row({});
    for (@{$csv_row}){
       my $cell = $row->add_cell({ text => $_ });
       $table->add_to_column($cell);
    }
}

warn Dumper $table;
warn Dumper $aoa;

done_testing();
1;

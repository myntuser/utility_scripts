use strict;
use warnings;
use Text::CSV;

my $csv = Text::CSV->new({ sep_char => ','});
my $file = "airports.csv";
open(my $data, '<', $file);
while(my $line = <$data>){
	chomp $line;
	if($csv->parse($line)){
		my @fields = $csv->fields();
		print "$fields[2]"."\n";
	}
}
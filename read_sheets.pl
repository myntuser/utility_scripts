use strict;
use warnings;


my $file = 'airports.csv';
open(my $data, '<', $file) or die "no such file";
while(my $line = <$data>){
	chomp $line;
	my @cols = split /,/, $line;
	print @cols[2]."\n" if not @cols[2] =~ /heliport/ and not @cols[2] =~ /small_airport/;
}
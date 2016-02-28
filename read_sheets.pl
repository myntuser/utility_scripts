use strict;
use warnings;
use Switch;
use Regexp::Common;
use Tie::IxHash;


main();

# main
sub main {
	my @headers = get_header();
	my %headers_map;
	tie %headers_map, 'Tie::IxHash';
	%headers_map = convert_array_to_hash(@headers);
	my $pos = get_col_pos_from_header('ident', %headers_map);
	read_file(\&get_column_by_pos, $pos);
}

# read file
sub read_file {
	my $file = 'airports.csv';
	open(my $fh, '<', $file) or die "no such file";
	my $func = $_[0];
	my $pos = $_[1];
	while(my $line = <$fh>){
		chomp $line;
		my @cols = split /,/, $line;
		$func->($pos, \@cols);
	}
	close $fh;
}

# get column by position
sub get_column_by_pos {
	my $pos;
	my @cols;
	my ($one, $two) = @_;
	$pos = $one;
	@cols = @{$two};
	write_to_file($cols[$pos]);
}


# get column pos from headers
sub get_col_pos_from_header {
	my %headers_map;
	tie %headers_map, 'Tie::IxHash';
	my $header;
	($header, %headers_map) = @_;
	my $i = 0;
	foreach my $v (values %headers_map) {
		if ($v =~ $header) {
			last;
		}
		$i = $i + 1;
	}
	return $i;
}

# get header
sub get_header {
	my $file = 'airports.csv';
	open(my $fh, '<', $file) or die "file not found";
	my $header = <$fh>;
	close $fh;
	my @headers = split /,/, $header;
	return @headers;
}

# convert array to hash
sub convert_array_to_hash {
	my %headers_map;
	tie %headers_map, 'Tie::IxHash';
	my $count = 1;
	foreach my $i (@_) {
		$headers_map{$count} = $i;
		$count = $count + 1;
	}
	return %headers_map;
}


# To list the airport by type
sub get_col_by_type {
	my ($one, $sec) = @_;
	my $type = $one;
	my @cols = @{$sec};
	if ($cols[2] =~ $type) {
		write_to_file(@cols);
	}
}

# write to file
sub write_to_file {
	open(my $fh, '>>', 'output.txt') or die "can't write to file";
	foreach my $i (@_) {
		print $fh "$i\t";
	}
	print $fh "\n";
	close $fh;
}

# remove file if exists;
sub remove_file_if_exist {
	my @args = @_;
	if (unlink($args[0]) == 0) { print "couldn't delete the file"; }
}

# get records by id
sub get_col_by_id {
	my ($one, $sec, $third) = @_;
	my $id = $one;
	my $op = $sec;
	my @cols = @{$third};
	if ($cols[0] =~ /$RE{num}{int}/)  {
		switch ($op) {
			case '=' {
				if ($cols[0] == $id) {
					write_to_file(@cols);
				}
			}
			case '>' {
				if ($cols[0] > $id) {
					write_to_file(@cols);
				}
			}
			case '<' {
				if ($cols[0] < $id) {
					write_to_file(@cols);
				}
			}
			case '>=' {
				if ($cols[0] > $id or $cols[0] == $id) {
					write_to_file(@cols);
				}
			}
			case '=<' {
				if ($cols[0] < $id or $cols[0] == $id) {
					write_to_file(@cols);
				}
			}
		}
	}
}
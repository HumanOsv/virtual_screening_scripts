#!/usr/bin/perl

use strict;
use warnings;


###################################
# read files
sub read_file {
	# filename
	my ($filename) = @_;
	(my $input_file = $filename) =~ s/\s//g;
	my @array          = ();
	# open file
	open(FILE, "<", $input_file ) || die "Can't open $input_file: $!";
	while (my $row = <FILE>) {
		chomp($row);
		push (@array,$row);
	}
	close (FILE);
	# return array
	return @array;
}
#

my ($energy) = @ARGV;
if (not defined $energy) {
	die "\nExtract Coords of AutoDock-Vina must be run with:\n\nUsage:\n\t03Extract_Coords.pl [Energy]\n";
	exit(1);
}

#
my @data_files     = ();
my @data_files_ext = ();
#
my @tmp_data_out = read_file("ID_Energy_Final.log");
#
my @id_mol = ();
my @Energy = ();
#
for ( my $i=0; $i < scalar(@tmp_data_out) ; $i++) {
	my @axis         = split ('\s+',$tmp_data_out[$i]);
	my $ID_file      = $axis[0];
	my $Energy_Bind  = $axis[1];
	if ( $Energy_Bind < $energy ) {
		#
		my @tmp_data_out = read_file("OUT-$ID_file.pdbqt");
		my $counter = 0;
		my $line_1  = 0;
		my $line_2  = 0;
		#
		my @array_first  = ();
		my @array_second = ();
		foreach my $a_1 (@tmp_data_out) {
			# MODEL 1 or REMARK VINA RESULT
			if ( ($a_1=~/REMARK/gi ) && ($a_1=~/VINA/gi ) && ($a_1=~/RESULT/gi ) ){
				$line_1 = $counter;
				push ( @array_second,$line_1);
			}
			# MODEL 2
			if ( ($a_1=~/ENDMDL/gi ) ){
				$line_2 = $counter;
				push (@array_first,$line_2);
			}
			$counter++;
		}
		my $first_x = $i + 1;
		#
		my $id = sprintf '%.3d', $i;
		#
  	my $filename = "$id-$ID_file.pdbqt";
		open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
		print $fh "MODEL $first_x\n";
		foreach my $a_1 ($array_second[0] .. $array_first[0]) {
			print $fh "$tmp_data_out[$a_1]\n";
		}
		close ($fh);
	}
}

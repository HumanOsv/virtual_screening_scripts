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
#
my @data_files     = ();
my @data_files_ext = ();
# directorio
my $dir = './';
# abrir directorio
opendir(DIR, $dir) or die $!;
my $counte = 0;
while (my $file = readdir(DIR)) {
	# Use a regular expression to ignore files beginning with a period
	next if ($file =~ m/^\./);
	next unless ($file =~ m/\.txt$/);
	push (@data_files,$file);
}
closedir(DIR);
#
my @id_mol = ();
my @Energy = ();
#
for ( my $i=0; $i < scalar(@data_files) ; $i++) {
	my $fileSnExt = $data_files[$i];
	$fileSnExt =~ s/\..*$//;
	#
	# Normal termination
	my $filex = "$fileSnExt.txt";
	my @tmp_data_out = read_file($filex);
	my $counter = 0;
	my $line_1  = 0;
	foreach my $a_1 (@tmp_data_out) {
		# mode |   affinity | dist from best mode
		if ( ($a_1=~/mode/gi ) && ($a_1=~/affinity/gi ) && ($a_1=~/best/gi ) ){
			$line_1 = $counter;
		}
		$counter++;
	}
	my $Num_E    = $line_1 + 3;
	my @axis     = split ('\s+',$tmp_data_out[$Num_E]);
	my $Bind_En  = $axis[2];
	#
	my $name_dock= substr $fileSnExt, 4, 200;
	push (@id_mol,$name_dock);
	push (@Energy,$Bind_En);
	print "filename = $name_dock.txt\n";
}
#
my @value_energy_sort = ();
my @value_id_sort     = ();
my @idx               = sort { $Energy[$a] <=> $Energy[$b] } 0 .. $#Energy;
@value_energy_sort    = @Energy[@idx];
@value_id_sort        = @id_mol[@idx];
#
my $filenames = 'ID_Energy_Final.log';
open(my $fh, '>', $filenames) or die "Could not open file '$filenames' $!";
for ( my $i=0; $i < scalar(@value_energy_sort) ; $i++) {
	print $fh "$value_id_sort[$i]  $value_energy_sort[$i]\n";
}
close $fh;
print "\n>> Fin Programa\n\n";

#!/usr/bin/perl

use strict;
use warnings;



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
	next unless ($file =~ m/\.pdbqt$/);
	push (@data_files,$file);
}
closedir(DIR);
#
my @id_mol = ();
#
for ( my $i=0; $i < scalar(@data_files) ; $i++) {
	my $fileSnExt = $data_files[$i];
	$fileSnExt =~ s/\..*$//;
	#
	# Normal termination
	if ( ($fileSnExt=~/RMas_Model_Final/gi ) ){
		print "\nReceptor = $fileSnExt\n";
	} else {
		print "\n >>  $fileSnExt.pdbqt  <<\n";
		open (FILE, ">CONF-$fileSnExt.inp") or die "Unable to open file: CONFIG-$fileSnExt.txt";
		print FILE "receptor = RMas_Model_Final.pdbqt\n";
		print FILE "ligand = $fileSnExt.pdbqt\n";
		print FILE "\n";
		print FILE "center_x =  0.77\n";
		print FILE "center_y = 28.26\n";
		print FILE "center_z = 31.26\n";
		print FILE "\n";
		print FILE "size_x = 30.75\n";
		print FILE "size_y = 30.75\n";
		print FILE "size_z = 30.75\n";
		print FILE "\n";
		print FILE "out = OUT-$fileSnExt.pdbqt\n";
		print FILE "log = LOG-$fileSnExt.txt\n";
		print FILE "\n";
		print FILE "cpu = 10\n";
		print FILE "exhaustiveness = 20\n";
		print FILE "num_modes = 20\n";
		close (FILE);
		#/Users/osvaldoyanezosses/Documents/autodock_vina_1_1_2/bin
		#system ("vina --config CONFIG-$fileSnExt.txt");
	}
}
#
for ( my $i=0; $i < scalar(@data_files) ; $i++) {
	my $fileSnExt = $data_files[$i];
	$fileSnExt =~ s/\..*$//;
	#
	#print "Delete: $fileSnExt\n";
	#unlink ("CONFIG-$fileSnExt.txt");
}
#
print "\n>> Fin Programa Vina \n\n";

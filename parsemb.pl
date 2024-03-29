#!/usr/bin/env perl
#===============================================================================
=pod


=head2

         FILE: parsemb.pl

        USAGE: ./parsemb.pl file.pstat > file.fas
               ./parsemb.pl file.pstat > file.fas 2> file.txt
               ./parsemb.pl -c 0.95 -u N file.pstat

  DESCRIPTION: Reads the output from a ancestral state reconstruction in MrBayes
               and prints the most probable inferred state(s) in fasta format.
               The fasta sequence is printed to STDOUT, and the table with
               probabilities is written to STDERR.

      OPTIONS: -c, --cutoff=<number>      Only show states with probability above
                                          <number> (between 0 and 1), otherwise
                                          print <unknown char>.
               -u, --unknown=<character>  Symbol to represent unknown value.
                                          Default '?'.
               -h, --help                 Show documentation.

 REQUIREMENTS: Perl v >= 5.017011, perldoc

         BUGS: ---

        NOTES: Requires specific format in the .pstat file. See README-file.

       AUTHOR: Johan Nylander (JN), johan.nylander@{nrm|nbis}.se

      COMPANY: NRM/NBIS

      VERSION: 1.0

      CREATED: 09/20/2017 04:04:00 PM

     REVISION: Thu 6 okt 2022 17:12:46

=cut


#===============================================================================

use strict;
use warnings;
use Getopt::Long;

no if $] >= 5.017011, warnings => 'experimental::smartmatch';

exec("perldoc", $0) unless (@ARGV);

my $cutoff  = 0;
my $unknown = '?';

my $r = GetOptions(
    "cutoff:s"  => \$cutoff,
    "unknown:s" => \$unknown,
    "help"      => sub { exec("perldoc", $0); exit(0); },
);

my %charH = ();
my @consA = ();

while(<>) {
    chomp;
    next if /^#/;
    if (/^p\((\w)\)\{(\d+)@(\w+)}\s(\S+)\s/) {
        my $charstate = $1;
        my $position = $2;
        my $constraint = $3;
        my $prob = $4;
        $charH{$constraint}{$position}{$charstate} = $prob;
        push (@consA, $constraint) unless ($constraint ~~ @consA);
    }
}

die "Error. Could not read name of constraint.\n" unless (@consA);

foreach my $con (@consA) {
    print STDERR "# $con\n";
    my @seq = ();
    for my $char (sort {$a <=> $b} keys %{$charH{$con}}) {
        print STDERR "$char\t";
        my @carr = ();
        for my $state (sort { $charH{$con}{$char}{$b} <=> $charH{$con}{$char}{$a} } keys %{$charH{$con}{$char}}) {
            print STDERR "$state=$charH{$con}{$char}{$state}\t";
            if ($charH{$con}{$char}{$state} > $cutoff) {
                push @carr, $state;
            }
            else {
                push @carr, $unknown;
            }
        }
        my $best = shift(@carr);
        push @seq, $best;
        print STDERR "\n";
    }
    print STDOUT ">", $con, " Ancestral states at node ", $con, "\n";
    print @seq;
    print STDOUT "\n";
}

__DATA__
[ID: 8397463132]
Parameter	Mean	Variance	Lower	Upper	Median	ESS
TL{all}	8.451976e-01	3.219059e-03	7.451509e-01	9.378537e-01	8.402844e-01	7.600000e+01
pi(A){1}	2.583066e-01	2.735304e-04	2.284355e-01	2.822690e-01	2.576484e-01	4.272588e+01
pi(C){1}	2.160816e-01	3.637328e-04	1.769348e-01	2.533276e-01	2.148997e-01	1.370945e+01
pi(G){1}	1.960297e-01	2.314147e-04	1.681086e-01	2.209156e-01	1.920370e-01	7.600000e+01
pi(T){1}	3.295822e-01	2.919152e-04	2.949825e-01	3.596598e-01	3.298006e-01	3.076830e+01
p(0){485@MyConstraint}	6.361512e-01	4.194524e-02	2.295625e-01	9.061681e-01	7.134735e-01	7.600000e+01
p(1){485@MyConstraint}	6.577902e-02	1.682555e-03	8.912052e-03	1.445629e-01	5.797919e-02	7.600000e+01
p(2){485@MyConstraint}	2.980698e-01	3.295702e-02	7.245431e-02	6.258746e-01	2.345589e-01	7.600000e+01
p(0){486@MyConstraint}	4.200920e-02	1.376030e-03	5.036058e-03	1.070307e-01	3.059489e-02	6.421023e+01
p(1){486@MyConstraint}	9.579908e-01	1.376030e-03	8.843488e-01	9.933838e-01	9.702177e-01	6.421024e+01
p(0){487@MyConstraint}	8.459564e-03	1.714371e-05	2.098631e-03	1.608029e-02	7.802237e-03	7.600000e+01
p(1){487@MyConstraint}	6.360484e-04	2.535693e-07	6.909193e-05	1.453726e-03	5.613016e-04	7.600000e+01
p(2){487@MyConstraint}	9.909044e-01	1.992111e-05	9.824659e-01	9.976470e-01	9.915262e-01	7.600000e+01
p(0){488@MyConstraint}	2.806066e-02	5.548571e-04	2.531434e-03	6.239393e-02	2.080371e-02	7.600000e+01
p(1){488@MyConstraint}	9.693519e-01	6.520830e-04	9.287139e-01	9.962842e-01	9.774535e-01	7.600000e+01
p(2){488@MyConstraint}	2.587463e-03	5.776289e-06	1.172472e-04	5.879564e-03	2.110881e-03	7.600000e+01
p(0){489@MyConstraint}	7.198033e-03	1.584120e-05	1.175904e-03	1.443102e-02	6.650630e-03	7.600000e+01
p(1){489@MyConstraint}	8.419819e-04	7.504397e-07	5.039714e-05	2.014267e-03	5.415269e-04	7.600000e+01
p(2){489@MyConstraint}	9.919600e-01	1.696443e-05	9.840898e-01	9.982065e-01	9.927529e-01	7.600000e+01
p(0){490@MyConstraint}	5.094045e-01	2.578642e-02	2.530895e-01	7.877659e-01	5.251557e-01	7.600000e+01
p(1){490@MyConstraint}	2.672478e-02	2.258229e-04	3.582689e-03	4.777054e-02	2.537778e-02	7.600000e+01
p(2){490@MyConstraint}	4.638707e-01	2.699009e-02	1.660562e-01	7.256308e-01	4.545312e-01	7.600000e+01
p(0){485@My2ndConstraint}	6.361512e-01	4.194524e-02	2.295625e-01	9.061681e-01	7.134735e-01	7.600000e+01
p(1){485@My2ndConstraint}	6.577902e-02	1.682555e-03	8.912052e-03	1.445629e-01	5.797919e-02	7.600000e+01
p(2){485@My2ndConstraint}	2.980698e-01	3.295702e-02	7.245431e-02	6.258746e-01	2.345589e-01	7.600000e+01
p(0){486@My2ndConstraint}	4.200920e-02	1.376030e-03	5.036058e-03	1.070307e-01	3.059489e-02	6.421023e+01
p(1){486@My2ndConstraint}	9.579908e-01	1.376030e-03	8.843488e-01	9.933838e-01	9.702177e-01	6.421024e+01
p(0){487@My2ndConstraint}	8.459564e-03	1.714371e-05	2.098631e-03	1.608029e-02	7.802237e-03	7.600000e+01
p(1){487@My2ndConstraint}	6.360484e-04	2.535693e-07	6.909193e-05	1.453726e-03	5.613016e-04	7.600000e+01
p(2){487@My2ndConstraint}	9.909044e-01	1.992111e-05	9.824659e-01	9.976470e-01	9.915262e-01	7.600000e+01
p(0){488@My2ndConstraint}	2.806066e-02	5.548571e-04	2.531434e-03	6.239393e-02	2.080371e-02	7.600000e+01
p(1){488@My2ndConstraint}	9.693519e-01	6.520830e-04	9.287139e-01	9.962842e-01	9.774535e-01	7.600000e+01
p(2){488@My2ndConstraint}	2.587463e-03	5.776289e-06	1.172472e-04	5.879564e-03	2.110881e-03	7.600000e+01
p(0){489@My2ndConstraint}	7.198033e-03	1.584120e-05	1.175904e-03	1.443102e-02	6.650630e-03	7.600000e+01
p(1){489@My2ndConstraint}	8.419819e-04	7.504397e-07	5.039714e-05	2.014267e-03	5.415269e-04	7.600000e+01
p(2){489@My2ndConstraint}	9.919600e-01	1.696443e-05	9.840898e-01	9.982065e-01	9.927529e-01	7.600000e+01
p(0){490@My2ndConstraint}	5.094045e-01	2.578642e-02	2.530895e-01	7.877659e-01	5.251557e-01	7.600000e+01
p(1){490@My2ndConstraint}	2.672478e-02	2.258229e-04	3.582689e-03	4.777054e-02	2.537778e-02	7.600000e+01
p(2){490@My2ndConstraint}	4.638707e-01	2.699009e-02	1.660562e-01	7.256308e-01	4.545312e-01	7.600000e+01

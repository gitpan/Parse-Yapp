#!/usr/bin/perl
#
# yapp.pl -- Front end to the Parse::Yapp module
#
# (c) Copyright 1998 Francois Desarmenien, all rights reserved.
# (see the pod text in Parse::Yapp module for use and distribution rights)
#
#
require 5.004;

use File::Basename;
use Getopt::Std;
use Parse::Yapp;

use strict;

use vars qw ( $opt_m $opt_V $opt_v $opt_o $opt_h $opt_s );

sub Usage {
	my($prog)=(fileparse($0,'\..*'))[0];
	die <<EOF;
Usage:
	$prog [-m module] [-v] [-s] [-o filename] grammar[.yp]
or	$prog -V
or	$prog -h

    -m module   Give your parser module the name <module>
                default is <grammar>

    -v          Create a file <grammar>.output describing your parser

    -s          Create a standalone module in which the driver is included

    -o outfile  Create the file <outfile> for your parser module
                Default is <grammar>.pm or, if -m A::Module::Name is
                specified, Name.pm

    grammar     The grammar file. If no suffix is given, and the file
                does not exists, .yp is added

    -V          Display current version of Parse::Yapp and gracefully exits

    -h          Display this help screen
EOF
}

my($nbargs)=@ARGV;

	getopts('Vhvsm:o:')
or	Usage;

   (  ($opt_V and $nbargs > 1)
    or $opt_h)
and Usage;

	$opt_V
and do {

    @ARGV == 0 or  Usage;

    print "This is Parse::Yapp version $Parse::Yapp::Driver::VERSION.\n";
    exit(0);

};

    @ARGV == 1
or  Usage;

my($filename)=$ARGV[0];
my($base,$path,$sfx)=fileparse($filename,'\..*');

	-r "$filename"
or	do {
		$sfx eq '.yp'
	or	$filename.='.yp';

		-r "$filename"
	or	die "Cannot open $filename for reading.\n";
};

open(IN,"<$filename");
my($grammar)=join('',<IN>);
close(IN);

my($parser)=new Parse::Yapp($grammar);

my($warnings)=$parser->Warnings();

	$warnings
and	print STDERR $warnings;

	$opt_v
and	do {
	my($output)="$base.output";
	my($tmp);

		open(OUT,">$output")
	or	die "Cannot create $base.output for writing.\n";

		$tmp=$parser->Warnings()
	and	print	OUT "Warnings:\n---------\n$tmp\n";
		$tmp=$parser->Conflicts()
	and	print	OUT "Conflicts:\n----------\n$tmp\n";
	print	OUT "Rules:\n------\n";
	print	OUT $parser->ShowRules()."\n";
	print	OUT "States:\n-------\n";
	print	OUT $parser->ShowDfa()."\n";
	print	OUT "Summary:\n--------\n";
	print	OUT $parser->Summary();

	close(OUT);
};

my($outfile)="$base.pm";
my($package)="$base";

	$opt_m
and	do {
    $package=$opt_m;
    $package=~/^(?:(?:[^:]|:(?!:))*::)*(.*)$/;
    $outfile="$1.pm";
};

	$opt_o
and	$outfile=$opt_o;

	open(OUT,">$outfile")
or	die "Cannot open $outfile for writing.\n";

print OUT $parser->Output($package,$opt_s);

close(OUT);

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

use vars qw ( $opt_m $opt_v $opt_o $opt_h );

sub Usage {
	my($prog)=(fileparse($0,'\..*'))[0];
	die <<EOF;
Usage:
	$prog [-m module] [-v] [-o filename] grammar[.yp]
or	$prog -h

    -m module   Give your parser module the name <module>
                default is <grammar>

    -v          Create a file <grammar>.output describing your parser

    -o outfile  Create the file <outfile> for your parser module
                Default is <grammar>.pm

    grammar     The grammar file. If no suffix is given, .yp is added

    -h          Display this help screen
EOF
}

	getopts('hvm:o:') and not $opt_h and @ARGV == 1
or	Usage;

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
	my($output)="$path$base.output";
	my($tmp);

		open(OUT,">$output")
	or	die "Cannot create $path$base.output for writing.\n";

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

my($outfile)="$path$base.pm";
my($package)="$base";

	$opt_m
and	$package=$opt_m;

	$opt_o
and	$outfile=$opt_o;

	open(OUT,">$outfile")
or	die "Cannot open $outfile for writing.\n";

print OUT $parser->Output($package);

close(OUT);

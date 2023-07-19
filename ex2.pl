#!/usr/bin/perl -w

# Purpose :
# Remake coding style

# Creation Date: 07/11/2023

# Last Modified: Tuesday, July 11, 2023 4:52:59 PM

# Created by: Vi Cao

##################################################
### Define Lib ###
use strict;
use warnings;
### END Lib ###

my $inputFilePath = "D:\\Documents\\Thuc_tap_Dolphin\\Perl\\PerlProgamming\\inputContent.txt";
my $outputFilePath = "D:\\Documents\\Thuc_tap_Dolphin\\Perl\\PerlProgamming\\outputContent.txt";

# Open the file for reading or writing
open(my $fileHandle1, '<', $inputFilePath) or die "Can not open file $inputFilePath: $!";
open(my $fileHandle2, '>', $outputFilePath) or die "Can not open file $outputFilePath: $!";

my $printFlag = 0;
while (my $line = <$fileHandle1>) {
  chomp $line; # remove the newline character '\n'

  # check: '=~' find substring in string
  if ($line =~ ".data") {
    $printFlag = 1;
  }

  if ($line =~ ".enddata") {
    $printFlag = 0;
    print $fileHandle2 "$line\n";
  }

  if ($printFlag) {
    print $fileHandle2 "$line\n";
  }
}
print "\nHoan tat!";
close($fileHandle1) or die "Cannot close file $inputFilePath: $!";
close($fileHandle2) or die "Cannot close file $outputFilePath: $!";

#!/usr/bin/perl -w

# Purpose :
# Remake coding style

# Creation Date: 07/12/2023 m-d-y

# Last Modified: Friday, July 14, 2023 2:41:41 PM

# Created by: Vi Cao

##################################################
### Define Lib ###
use strict;
use warnings;
### END Lib ###

# Open file by argument
die "$0 requires an argument.\n" if $#ARGV < 1 ;
open(V, '<', $ARGV[0]) || die "Can't open file $ARGV[0]: $!\n";
open(LEF, '<', $ARGV[1]) || die "Can't open file $ARGV[1]: $!\n";

# Get array pins
my @pinsOfV;
my @pinsOfLEF;

while (my $line = <V>) {
  if ($line =~ /input|output|inout/) {
    $line =~ s/\s*\/\/.*$//;  # Remove everything after //
    $line =~ s/^\s*//;
    my @temp = $line =~ /\b(\w+)\b/g;
    push(@pinsOfV, "@temp\n");
  }
}

while (my $line = <LEF>) {
  if ($line =~ /PIN/) {
    $line =~ s/\s*\/\/.*$//;  # Remove everything after //
    $line =~ s/^\s*//; 
    my @temp = $line =~ /\b(\w+)\b/g;
    push(@pinsOfLEF, "@temp\n");
  }
}

# Get Hash's value pins
my %hashPinV;
my %hashPinLEF;

# Hash's value pins of File .v
for my $value (@pinsOfV) {
  my @temp = split(" ", $value);
  my $length = scalar(@temp);
  if ($length == 2) {           #### Format temp: input a;
    $hashPinV{$temp[1]} = "";
  }
  elsif ($length == 4) {        ### Format temp: input 127 0 a;
    $hashPinV{$temp[3]} = join(" ", $temp[1], $temp[2]);
  }
}

# Hash's value pins of File .LEF
for my $value (@pinsOfLEF) {

  my @temp = split(" ", $value);
  my $length = scalar(@temp);

  if ($length == 2) {           #### Format temp: pin a;
    $hashPinLEF{$temp[1]} = "";
  }

  elsif ($length == 3) {        ### Format temp: pin a 0;

    if (exists $hashPinLEF{$temp[1]}) {
      my $arrayIndex = $hashPinLEF{$temp[1]};
      $arrayIndex .= "$temp[2] ";
      $hashPinLEF{$temp[1]} = $arrayIndex;
    }
    else {
      $hashPinLEF{$temp[1]} = "$temp[2] ";
    }
  }
}

my $twoFileTheSame = comparePins(\%hashPinV, \%hashPinLEF);
if ($twoFileTheSame) {
  print "GOOD";
}
else {
  print "ERROR";
}

# Close file
close(V);
close(LEF);

############ sub ##############

sub printHash {
  my ($hashResult) = @_;
  my $key;
  my $value;

  while ( ($key, $value) = each %$hashResult) {
    print "\n$key : $value";
  }
}

# Compare the pins of two files, one with a .v extension and the other with a .lef extension,
# and the information of these pins has been stored in two hash data structures.
sub comparePins {
  my ($hashRef1, $hashRef2) = @_;
  my %hashV = %$hashRef1;
  my %hashLEF = %$hashRef2;

  my $numberOfV = scalar %hashV;
  my $numberOfLEF = scalar %hashLEF;

  if ($numberOfV != $numberOfLEF) {
    return 0;
  }

  for my $keyOfV(keys %hashV) {

    if (exists($hashLEF{$keyOfV})) {

      if ($hashPinV{$keyOfV} ne $hashPinLEF{$keyOfV}) {

        my ($endOfV, $beginOfV) = split(" ", $hashPinV{$keyOfV});
        my @numPinsOfLEF = split(" ", $hashPinLEF{$keyOfV});
        
        for ( my $temp = $beginOfV; $temp <= $endOfV; $temp++ ) {

          if (existInArray($temp, \@numPinsOfLEF) == 0) {
            return 0;
          }

        }

      }

    }
    else {
      return 0;
    }

  }
  
  return 1;
  printHash(\%hashV);
  printHash(\%hashLEF);
}

# find a number in an array. If found return 1; else return 0.
sub existInArray {

  my ($number, $arrayRef) = @_;
  my @array = @$arrayRef;

  for my $element (@array) {

    if ($number == $element) {
      return 1;
    }
  }

  return 0;
}

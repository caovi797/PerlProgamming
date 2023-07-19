#!/usr/bin/perl -w

# Purpose :
# Remake coding style

# Creation Date: 07/12/2023 m-d-y

# Last Modified: Wednesday, July 12, 2023 9:20:23 AM

# Created by: Vi Cao

##################################################
### Define Lib ###
use strict;
use warnings;
### END Lib ###

# Open the file to reading
die "$0 requires an argument.\n" if $#ARGV < 0 ;
open(V, '<', $ARGV[0]) || die "Can't open file $ARGV[0]: $!\n";

my %hashFile;
my $lineIndex = 1;
while (my $line = <V>) {
  chomp $line;
  if ($lineIndex == 1) {
    $hashFile{"name"} = $line;
  }
  elsif ($lineIndex == 2) {
    $hashFile{"Date of birth"} = $line;
  }
  elsif ($lineIndex == 3) {
    $hashFile{"Place of birth"} = $line;
  }
  elsif ($lineIndex == 4) {
    $hashFile{"Address"} = $line;
  }

  $lineIndex++;
}

# Print the hash's content to screen
printHashContent(\%hashFile);

# Close the file
close(V) or die "Can not close file ";

####################### Sub ####################

sub printHashContent{
  my ($hashFile) = @_;
  for my $key (keys %$hashFile) {
    my $value = $hashFile{$key};
    print "$key: $value\n";
  }
}
#!/usr/bin/perl -w

# Purpose :
# Remake coding style

# Creation Date: 07/12/2023 m-d-y

# Last Modified: Wednesday, July 12, 2023 10:38:47 AM

# Created by: Vi Cao

##################################################
### Define Lib ###
use strict;
use warnings;
### END Lib ###

# Open the file to reading or writing
die "$0 requires an argument.\n" if $#ARGV < 1 ;
open(my $fileHandle1, '<', $ARGV[0]) || die "Can't open file $ARGV[0]: $!\n";
open(my $fileHandle2, '>', $ARGV[1]) || die "Can't open file $ARGV[1]: $!\n";


my %hashFile;
my $lineIndex = 1;
while (my $line = <$fileHandle1>) {
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

# Print the hash's content to a file
printHashContent(\%hashFile);

# Close the file
close($fileHandle1) or die "Can not open file $fileHandle1";
close($fileHandle2) or die "Can not open file $fileHandle2";


##################### Sub #########################################

sub printHashContent {
    my ($hashFile) = @_;
    for my $key (keys %$hashFile) {
    my $value = $hashFile{$key};
    print $fileHandle2 "$key: $value\n";
    }
}
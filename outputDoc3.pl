#!/usr/bin/perl -w

# Purpose : Write Boolen expresstion for outputs of each file.
# Remake coding style

# Creation Date: 07/17/2023 m-d-y

# Last Modified: Monday, July 17, 2023 8:59:09 AM

# Created by: Vi Cao

##################################################
### Define Lib ###
use strict;
use warnings;
use Data::Dumper;
### END Lib ###

# Open file from the arguments and read.
die "$0 requires an argument.\n" if $#ARGV < 0;
open(my $handleFile1, '<', $ARGV[0]) || die "Can't open file $ARGV[0]: $!\n";

my $readFlag = 0;

my %inputHash;
my %outputHash;
my %wireHash;
my %assignHash;

my $command = "";
my $tempCommand = "";
while (my $newline = <$handleFile1>) {

  # Task1: Read file from "module" to "endmodule" and then remove everythings after "//".
  if ($newline =~ /^\s*module/) {
    $readFlag = 1;
  }
  elsif ($newline =~ /^\s*endmodule/) {
    $readFlag = 0;
  }
  
  if ($readFlag ==0 ) {
    next;
  }
  chomp($newline);
  $newline =~ s/\s*\/\/.*//; # Remove everything after //
  $newline =~ s/^\s*/ /;
  # end Task1

  # Task2: get command from head line to ";"
  $tempCommand .= $newline;
  if ($newline =~ /;/) {
    $command = $tempCommand;
    $tempCommand = "";
  }
  else {
    next;
  }

  # Task3: handle the commands
  if ($command =~ /input/i) {
    my @temp = $command =~ /\b(\w+)\b/g; # Format of @temp = ('input', 9, 0, 'ladd');

    for my $i ($temp[2] .. ($temp[1] + 1) ) {
      my $keyHash = "$temp[3]\[$i\]";
      $inputHash{$keyHash} = undef;
    }

  }

  elsif ($command =~ /output/i) {
    my @temp = $command =~ /\b(\w+)\b/g; # Format of @temp = ('output', 9, 0, 'padd');

    for my $i ($temp[2] .. $temp[1] ) {
      my $keyHash = "$temp[3]\[$i\]";
      $outputHash{$keyHash} = undef;
    }
  }

  # elsif ($command =~ /wire.*[\[\]]+.*$/i) {
  #   my @temp = $command =~ /\b(\w+)\b/g; # Format of @temp = ('wire', '9', '0', 'laddr_adj_0').

  #   for my $i ($temp[2] .. ($temp[1] + 1) ) {
  #     my $keyHash = "$temp[3]\[$i\]";
  #     $wireHashHash{$keyHash} = undef;
  #   }
  # }

  # Dang dinh cho tat ca deu la wire (assign,wire,...)
  elsif ($command =~ /\s*assign.*=.*/) {
    my @temp = $command =~ /\s*assign\s+(\S+)\s*=\s*(\S+);/g;  # Format of @temp = ['laddr_adj_0[5]', 'laddr[5]']
    $wireHash{$temp[0]} = $temp[1];
  }
  # print Dumper(\%wireHash);

  ############################################################################################
  my @temp = $command =~ /\.\w+\((\S+)\)/gi; # Format of @temp = ('a' ,'b', 'c', 'z').
  my $keyHash = $temp[$#temp];               #get last element (output) as key of hash.
  pop(@temp);                                #remove last element (as remove output).
  # if the element is wire, replace it to be inputs format.
  for my $i (0 .. $#temp ) {
    if ( exists ( $wireHash{$i} ) ) {
      $temp[$i] = $wireHash{$i};
    }
  }

  if ($command =~ /dti_55g_10t_inv/) {
    if ( exists( $outputHash{$keyHash} ) ) {
      $outputHash{$keyHash} = inv_operator(\@temp);
    }
    else {
      $wireHash{$keyHash} = inv_operator(\@temp);
    }
    # print "$outputHash{$keyHash}\n";
  }

  elsif ($command =~ /dti_55g_10t_and/) {
    if ( exists( $outputHash{$keyHash} ) ) {
      $outputHash{$keyHash} = and_operator(\@temp);
    }
    else {
      $wireHash{$keyHash} = and_operator(\@temp);
    }
  } 

  elsif ($command =~ /dti_55g_10t_or/) {
    if ( exists( $outputHash{$keyHash} ) ) {
      $outputHash{$keyHash} = or_operator(\@temp);
    }
    else {
      $wireHash{$keyHash} = or_operator(\@temp);
    }
  }

  elsif ($command =~ /dti_55g_10t_xor/) {
    if ( exists( $outputHash{$keyHash} ) ) {
      $outputHash{$keyHash} = xor_operator(\@temp);
    }
    else {
      $wireHash{$keyHash} = xor_operator(\@temp);
    }
  }  

}



# print Dumper(\%outputHash);
# Close the files.
close($handleFile1) || die "Can't close file $ARGV[0]: $!\n";

############################# Define Subroutine ###########################
sub inv_operator {
  my ($input) = @_;
  return "(~ @$input)";
}

sub and_operator {
  my ($arrRefer) = @_;
  my @arrayInput = @$arrRefer;
  my $result = "($arrayInput[0]";

  for my $i (1 .. $#arrayInput) {
    $result .= " & $arrayInput[$i]";
  }

  $result .= ")";
  return $result;
}

sub or_operator {
  my ($arrRefer) = @_;
  my @arrayInput = @$arrRefer;
  my $result = "($arrayInput[0]";

  for my $i (1 .. $#arrayInput) {
    $result .= " | $arrayInput[$i]";
  }

  $result .= ")";
  return $result;
}

sub xor_operator {
  my ($arrRefer) = @_;
  my @arrayInput = @$arrRefer;
  my $result = "($arrayInput[0]";

  for my $i (1 .. $#arrayInput) {
    $result .= " ^ $arrayInput[$i]";
  }

  $result .= ")";
  return $result;
}

#Hôm qua đang kiểm tra tại sao vẫn chưa thay đổi wire thành dạng bao gồm các đầu vào
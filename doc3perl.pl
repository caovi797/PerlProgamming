use strict;
use warnings;

my $file = 'addr_conv_l2p_440_netlist.v';

sub read_and_print_file {
  my ($file) = @_;

if (defined $file) {
  open(my $filehandle, '<',$file) or die "can not open file: $!"; 
while (my $line = <$filehandle>) {
    print $line;
}
  close($filehandle);
} else {
  print "Failed\n";
  }
}
while (defined $ARGV[0]){
  open(my $filename = $ARGV[0]);
  read_and_print_file($filename);
}
# Open the .v file
open(my $V, "<", $ARGV[0]) or die "Can not open file: $!";

# Declare variables
my %inputs;
my %outputs;
my %wires;
my %expressions;
my %gateTypes;

# Process each line of the file
while (my $line = <$V>) {
    chomp($line);
    if ($line =~ /input (\w+)/) {
        $inputs{$1} = 1;
    }
    elsif ($line =~ /output (\w+)/) {
        $outputs{$1} = 1;
    }
    elsif ($line =~ /wire (\w+)/) {
        $wires{$1} = 1;
    }
    elsif ($line =~ /(\w+)\s*=\s*([^;]+)/) {
        my $output = $1;
        my $expression = $2;
        $expressions{$output} = $expression;
    }
    elsif ($line =~ /(\w+)\s*=\s*(\w+)\s*([^\(]+)\((.*)\)/) {
        my $output = $1;
        my $gateType = $2;
        my @inputs = split(",", $4);
        $gateTypes{$output} = $gateType;
        for my $i (0 .. $#inputs) {
            $inputs[$i] =~ s/^\s+|\s+$//g;
            $inputs[$i] =~ s/(\w+)$/$1/g;
            $inputs[$i] =~ s/(\w+)/$1/g;
        }
        $expressions{$output} = \@inputs;
    }
}

# Close the file
close($V);

# Define subroutines for gate types
sub inv1 {
    my $input = $_[0];
    return "(~$input)";
}

sub and2 {
    my ($input1, $input2) = @_;
    return "($input1 & $input2)";
}

sub or2 {
    my ($input1, $input2) = @_;
    return "($input1 | $input2)";
}

sub xor2 {
    my ($input1, $input2) = @_;
    return "($input1 ^ $input2)";
}

sub and3 {
    my ($input1, $input2, $input3) = @_;
    return "($input1 & $input2 & $input3)";
}

sub or3 {
    my ($input1, $input2, $input3) = @_;
    return "($input1 | $input2 | $input3)";
}

sub and4 {
    my ($input1, $input2, $input3, $input4) = @_;
    return "($input1 & $input2 & $input3 & $input4)";
}

# Process the expressions and generate the output
foreach my $output (sort keys %expressions) {
    my $expression = $expressions{$output};
    if (ref($expression) eq 'ARRAY') {
        my $gateType = $gateTypes{$output};
        my @inputs = @{$expression};
        if ($gateType eq 'inv') {
            $expression = inv1($inputs[0]);
        }
        elsif ($gateType eq 'and2') {
            $expression = and2($inputs[0], $inputs[1]);
        }
        elsif ($gateType eq 'or2') {
            $expression = or2($inputs[0], $inputs[1]);
        }
        elsif ($gateType eq 'xor2') {
            $expression = xor2($inputs[0], $inputs[1]);
        }
        elsif ($gateType eq 'and3') {
            $expression = and3($inputs[0], $inputs[1], $inputs[2]);
        }
        elsif ($gateType eq 'or3') {
            $expression = or3($inputs[0], $inputs[1], $inputs[2]);
        }
        elsif ($gateType eq 'and4') {
            $expression = and4($inputs[0], $inputs[1], $inputs[2], $inputs[3]);
        }
    }
    else {
        foreach my $input (keys %inputs) {
            $expression =~ s/\b$input\b/Input/g;
        }
        foreach my $wire (keys %wires) {
            $expression =~ s/\b$wire\b/$expressions{$wire}/g;
        }
    }
    $expressions{$output} = $expression;
}

# Write the output expressions to a file
open(my $output_V, ">", "output.txt") or die "Can not open output file: $!";
foreach my $output (sort keys %outputs) {
    print $output_V "$output = $expressions{$output}\n";
}
close($output_V);

print "Output expressions written to output.txt file\n";

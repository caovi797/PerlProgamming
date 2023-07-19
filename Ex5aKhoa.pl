#! /usr/bin/perl -w
#Perl script to compare 2 PIN list in 2 file .v and .lef
#as 3.6 ex5

use strict;

open(V,'<',$ARGV[0]) or die "Can't open : $!\n"; #ARGV[0] la file .v
open(LEF,'<',$ARGV[1]) or die "Can't open : $!\n"; #ARGV[1] la file .lef
my @gatename;
my @gatenum;
my $i;
my $j;
my @x;
my $result = "GOOD";
my @condition;
my $str;
my @count;
#lay list pin cua file .v
while(my $String = <V>){
  if($String =~ /input|output|inout/){
    my @gate = split /\s+/,$String;
    my ($num,$name) = @gate[1,2];
    if($name =~ '//'){
      chop($num);
      push(@gatename,"$num");
      push(@gatenum,"inout");
    }
    else{
      chop($name);
      push(@gatename,"$name");
      push(@gatenum,"$num"); 
    }  
  }
}
my $size = scalar @gatename;
while($str = <LEF>){
  for($i=0;$i<$size;$i++ ){
    if($str =~ "PIN $gatename[$i]"){
    $count[$i]++;
    }
  } 
}
my %hash;
@hash{@gatename} = @gatenum;
foreach(@gatename){
  if($hash{$_} =~ "inout"){
    push(@condition,1);
  }
  else{
    @x = split ':',$hash{$_};
    my ($max,$min) = @x[0,1];
    chop($min);
    my $s = reverse($max);
    chop($s);
    $max = reverse($s);
    my $res = $max -$min +1;
    push(@condition,$res);
  }
}
for($j=0;$j<$size;$j++){
  if($count[$j] != $condition[$j]){
    $result = "ERROR";
  }
}
print "$result\n";
close(V);
close(LEF);
$first_name = "Melanie\t";
$last_name = "Quigley\n";
$salary = 125000.00;
print $first_name, $last_name, $salary;
#######################################

@names = ( "Jessica", "Michelle", "Linda" );
print "\n--------\n";
print "@names";  #Prints the array with elements separated by a space
print "$names[0] and $names[2]";  #Prints "Jessica" and "Linda"
print "$names[-1]\n";  # Prints "Linda"
$names[3]="Nicole";    #Assign a new value as the 4th element

#######################################
%employee =  (
   "Name"      => "Jessica Savage",
   "Phone"     => "(925) 555-1274",
   "Position"  => "CEO"
	 );

    print "\n--------\n";
    #print "$employee{"Name"};  # Print a value
    #$employee{"SSN"}="999-333-2345";  # Assign a key/value

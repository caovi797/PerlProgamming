sub modify_array {
  my ($array_ref) = @_;

  # Dereference the array reference and modify the array
  my @array = @$array_ref;
  push @array, "new element";
  push @$array_ref, "thanhnez";

  # Print the modified array
  print "Modified Array: @array\n";
}

# Create an array
my @original_array = ("element1", "element2");

# Pass a reference to the array to the subroutine
modify_array(\@original_array);

# Print the original array
print "Original Array: @original_array\n";

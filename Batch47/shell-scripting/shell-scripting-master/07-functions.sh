#!/bin/bash

## If you assign a name to set of data then it is variable
## If you assign a name to set of commands then it os function.

## Declare a function
function function_name() {
  commands
  commands
}

# OR

function_name() {
  commands
  coommands
}


## Examples

sample() {
  echo "Hello from Function"
  echo "Value of A = $a"
  b=20
}

demo() {
 echo "First Argument = $1"
 echo "Second Argument = $2"
 echo "All Arguments = $*"
 echo "Number of Arguments = $#"
 return 100
}
## Main Program
a=10
sample
echo "Value of B = $b"

demo abc xyz 10
echo Exit Status of Function = $?

## Observations:
# 1. Function is been called as a command, So function is a type of command.
# 2. Variables from Main Program can be accessed in function.
# 3. Variables declared in function can be accessed in Main Program
# 4. Functions should always be there before to Main Program.

#!/bin/bash

COURSE=$1

## If command depends on expressions

## Expressions
## 1. String Comparisions
### Operators : = , ==, !=, -z
  # Ex: [ string == string ], [ abc == abc ], [ $VAR == abc ], [ $VAR != abc ]

if [ -z "$COURSE" ]; then
  echo "Usage: $0 AWS|DEVOPS"
  exit 1
fi

if [ "$COURSE" = "AWS" ]; then
  echo "Welcome to AWS Training"
fi

## Note: Always provide variables inside conditional expressions with double quotes.


## 2. Numerical Comparisions
### Operators : -eq , -ne , -gt , -ge , -lt -le
  # Ex: [ 1 -eq 2 ], [ 2 -gt 3 ]

if [ $# -ne 3 ]; then
  echo "Usage: $0 AWS|DEVOPS TIMINGS AM|PM"
  exit 1
fi

NUMBER_OF_PROCESS=$(ps -ef | grep ssh  | grep -v grep | wc -l)

if [ "$NUMBER_OF_PROCESS" -gt 0 ]; then
  echo "Yes, SSH Process are running, Number = $NUMBER_OF_PROCESS"
else
  echo "No, No SSH Process are running"
fi

## 3. File Checks
## https://www.tldp.org/LDP/abs/html/fto.html

## Else IF

# if [ expression ]; then
# commands
# elif [ expression ]; then
# commands
# else
# commands
# fi


## Logical AND  & Logical OR are used to check multiple expressions.

# -a and -o works on []
# -a -> logical AND
# -o -> Logical OR

# && , || works on [[ ]]
# && -> Logical AND
# || -> Logical OR


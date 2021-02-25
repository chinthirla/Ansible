#!/bin/bash


# cp README.md /tmp
# script-name first-argument second-argument
# $0            $1             $2

# Special variables are $0-$n, $* $@, $#

echo "Script Name = $0"
echo "First Argument = $1"
echo "Second Argument = $2 "
echo "All Arguments = $*"
echo "All Arguments = $@"
echo "Number of Arguments = $#"

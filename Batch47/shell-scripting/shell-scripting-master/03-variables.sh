#!/bin/bash

## A name assigned to a set of data is called as a variable.

#Syntax: VARNAME=DATA

MESSAGE=HelloUniverse

echo $MESSAGE
echo ${MESSAGE}
# or it can also accessed as ${MESSAGE}

# A case where you need ${}
APPLE=10
echo Number of Apples = ${APPLE}n

## Data types - Characters, Numbers, Strings, Booleans, Floating

# But shell does not have data types by default, Everything is a string.
# Always we need to have an understanding that what data is inside.

a=abc
b=10
c=true
d=10.8
e=abc123

## All those are different data, but for shell it is string

echo "Hello, Good Morning, Today date is 2020-05-15"

# Dynamic Variables are two ways
# 1. Command Substitution
# syntax:  VAR=$(command)
# 2. Arithmetic Substitution
# Syntax: VAR=$((arithmetic expression))

DATE=$(date +%F)
echo "Hello, Good Morning, Today date is $DATE"
echo "Hello, Good Morning, Today date is $(date +%F)"


ADD=$((2+3+4+6))

echo ADD = $ADD

## We can also access the variables from command line

echo "Welcome to $COURSE Training "

## Observation: If a variable is declared then shell will not throw an error.


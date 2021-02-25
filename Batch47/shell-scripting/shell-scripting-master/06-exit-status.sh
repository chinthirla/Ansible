#!/bin/bash

## Exit states will help you identifying whether the command executed is completed successfully or not.

## Exit States are numbers , ranges from 0-255

# 0 - Successful
# 1-255 - Partial Success , Partial Failure , Complete Failure

## TO get that exit status we have to use a special variable ? , $?

## Now we are writing scripts, So we also need to tell some status to the shell that we are succeeded or failure.

# Users can use the exit states from 0-125 , Anything beyond 125 is used by system, Hence it is not recommended to use those values.

exit 10
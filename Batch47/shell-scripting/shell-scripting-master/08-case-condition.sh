#!/bin/bash

TRAINING=$1

case $TRAINING in
  AWS)
    echo "Welcome to AWS Training"
    echo "Batch Timings : 7AM to 8AM IST"
    echo "Trainer Name : Raju"
    echo "Demo Date: 17-May"
    echo "Batch Start Date: 18-May"
    ;;
  DEVOPS)
    echo "Welcome to DEVOPS Training"
    echo "Batch Timings : 6AM to 7AM IST"
    echo "Trainer Name : Raju"
    echo "Demo Date: 31-May"
    echo "Batch Start Date: 01-June"
    ;;
  *)
    echo "Sorry we dont serve that course"
    exit 1
esac

## Syntax:
# case $var in
# pattern1) commands ;;
# pattern2) commands ;;
# esac


## Observation
## Case command can just compare a value in variable with the list of patters given.

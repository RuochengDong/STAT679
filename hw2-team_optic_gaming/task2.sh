#!/bin/bash
set -e # script terminates if any command exits with non-zero status
set -u # terminates if any variable is unset
set -o pipefail # terminates if command within a pipes exits unsuccessfully


for filename in data/*.phy
do
    basename=$(basename -s .phy $filename) # get the base name of the file
    n_before=$(awk 'NR == 1 { print $1 }' $filename) # get number of rows before filtering
    n_after=$(awk 'NR == 1 { print $1 }' data_nomissing/$basename.phy) # get number of rows after filtering
    echo $basename,$n_before,$n_after >> results.csv # print the name, number of rows before and after filtering to the csv file
done

# number of alignments with no change
# max number of deletions (i.e. max value of n_before - n_after)
# total number of deletions (i.e. sum of all values of n_before - n_after)
awk -F "," 'BEGIN { same = 0; max = 0; sum = 0}; 
{ diff = ($2-$3) };
{ if (diff == 0) same += 1 };
{ if (diff >= max) max = diff };
{ sum += diff }; 
END { print "number of alignments with no change: " same;
print "max number of deletions: " max;
print "total number of deletions: " sum }'   results.csv

sed -i 1i"alignment","n_before","n_after" results.csv

  
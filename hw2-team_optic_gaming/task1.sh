#!/bin/bash
set -e # script terminates if any command exits with non-zero status
set -u # terminates if any variable is unset
set -o pipefail # terminates if command within a pipes exits unsuccessfully

# make a new folder
mkdir data_nomissing/

for filename in data/*.phy
do
    # get the file names
    basename=$(basename $filename)
    # create files without entire missing sequence
    awk '$2 !~ /^[\?\-N]+$/' $filename >> data_nomissing/$basename
    # update number of sequences
    n_line=$(wc -l data_nomissing/$basename | awk '{ print $1 }')
    n_after=$((n_line-1))
    # -E is neccessary for [0-9]+ to work
    sed -E -i "1 s/[0-9]+/$n_after/" data_nomissing/$basename 
done


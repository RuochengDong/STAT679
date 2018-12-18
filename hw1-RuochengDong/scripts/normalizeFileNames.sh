# Go to the log folder

cd log

# Change the names of files in log folder

for filename in timetest?_*
do
    mv $filename ${filename:0:8}0${filename:0-10}
done

# Go to the out folder

cd ../out

# Change the names of files in the out folder

for filename in timetest?_*
do
    mv $filename ${filename:0:8}0${filename:0-10}
done

#bin/bash
### run the script in a folder with *.yml files! :)
filenames=`ls *.yml`
for entry in $filenames; do
    echo $entry
    conda env create -f $entry
done

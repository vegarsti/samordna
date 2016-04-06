#!/bin/sh

# Necessary files:
# data/
#   - NTNU.txt
#   - UIO.txt
# utils/
#   - scorelines.awk
#   - 7lines.py
#   - gather.awk
#   - append_titles.py

# Create directory if it does not exist
mkdir -p processed

# Extract study ID and name from NTNU
cut -c 6-11 data/NTNU.txt > tmp-NTNU-1.txt
cut -c 13-62 data/NTNU.txt |
tr ',' ':' > tmp-NTNU-2.txt

for year in 2009 2010 2011 2012 2013 2014 2015; do
    sed -n '/Universitetet i Oslo/,/^$/p' years/${year}.txt >> UIO-2.txt
done

# Extract study ID and name from UIO
cut -c 5-10 data/UIO.txt > tmp-UIO-1.txt
cut -c 12-63 data/UIO.txt |
tr ',' ':' > tmp-UIO-2.txt

# Extract necessary info from files; only thing different between the two.
cut -c 5-11,83-87,93-96 data/UIO.txt > tmp-UIO.txt
#cut -c 5-11,81-87,93-96 UIO-2.txt > tmp-UIO.txt
cut -c 6-12,93-97,113-116 data/NTNU.txt > tmp-NTNU.txt

# Process data from both universities
for UNI in UIO NTNU; do
    awk -f utils/scorelines.awk tmp-${UNI}.txt | # Keep lines with actual scores
    sort -s -n -k 1,1 |                 # Sort by study ID; keep year order
    python utils/7lines.py |            # Keep those IDs with scores all 7 years
    tr ' ' ',' |                        # Replace spaces with commas
    awk -F ',' -f utils/gather.awk |    # Gather all 7 scores for ID on one line
    tr ' ' ',' > tmp.csv                # Replace spaces with commas

    # Split into the two separate files, one for ordinary, one for first
    awk 'NR % 2 == 1' tmp.csv > tmp-${UNI}-ORD.csv
    awk 'NR % 2 == 0' tmp.csv > tmp-${UNI}-FORST.csv

    # Add programme names
    paste -d ',' tmp-${UNI}-1.txt tmp-${UNI}-2.txt > ${UNI}-studies-IDs.txt
    mkdir -p processed/${UNI}
    python utils/append_titles.py tmp-${UNI}-ORD.csv processed/${UNI}/ORD.csv ${UNI}-studies-IDs.txt ${UNI}
    python utils/append_titles.py tmp-${UNI}-FORST.csv processed/${UNI}/FORST.csv ${UNI}-studies-IDs.txt ${UNI}
    #      utils/append_titles.py [file w/o names] [outfile] [file w/names] [uni]
done

# Cleanup
rm tmp*
rm *-studies-IDs.txt
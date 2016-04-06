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

# Extract NTNU and UIO data from complete year files
for year in 2009 2010 2011 2012 2013 2014 2015; do
    sed -n '/naturvitenskapelige/,/^$/p' data/${year}.txt >> data/NTNU.txt
    sed -n '/Universitetet i Oslo/,/^$/p' data/${year}.txt >> data/UIO.txt
done


# Extract programme ID and name

# NTNU
cut -c 6-11 data/NTNU.txt > tmp-NTNU-1.txt
cut -c 13-62 data/NTNU.txt |
tr ',' ':' > tmp-NTNU-2.txt
# UIO
cut -c 5-10 data/UIO.txt > tmp-UIO-1.txt
cut -c 12-63 data/UIO.txt |
tr ',' ':' > tmp-UIO-2.txt


# Extract IDs and scores

# NTNU
cut -c 6-12,92-96,110-116 data/NTNU.txt |
tr -s ' ' > tmp-NTNU.txt
# UIO
cut -c 5-11,82-87,93-96 data/UIO.txt |
tr -s ' ' > tmp-UIO.txt

# Create directory if it does not exist
mkdir -p processed

# Process data from both universities
for uni in UIO NTNU; do
    awk -f utils/scorelines.awk tmp-${uni}.txt | # Keep lines with actual scores
    sort -s -n -k 1,1 |                 # Sort by study ID; keep year order
    python utils/7lines.py |            # Keep those IDs with scores all 7 years
    tr ' ' ',' |                        # Replace spaces with commas
    awk -F ',' -f utils/gather.awk |    # Gather all 7 scores for ID on one line
    tr ' ' ',' > tmp.csv                # Replace spaces with commas

    # Split into the two separate files, one for ordinary, one for first
    awk 'NR % 2 == 1' tmp.csv > tmp-${uni}-ORD.csv
    awk 'NR % 2 == 0' tmp.csv > tmp-${uni}-FORST.csv

    # Add programme names
    paste -d ',' tmp-${uni}-1.txt tmp-${uni}-2.txt > ${uni}-studies-IDs.txt
    mkdir -p processed/${uni}
    python utils/append_titles.py tmp-${uni}-ORD.csv processed/${uni}/ORD.csv ${uni}-studies-IDs.txt ${uni}
    python utils/append_titles.py tmp-${uni}-FORST.csv processed/${uni}/FORST.csv ${uni}-studies-IDs.txt ${uni}
    #      utils/append_titles.py [file w/o names] [outfile] [file w/names] [uni]

    rm data/${uni}.txt
done

# Cleanup
rm tmp*
rm *-studies-IDs.txt
#!/bin/sh

# Necessary files:
# data/
#   - 2009.txt
#   - 2010.txt
#   - ...
#   - 2015.txt
# utils/
#   - scorelines.awk
#   - 7lines.py
#   - gather.awk
#   - append_titles.py

# Ensure empty files (only necessary if last run crashed, really)
for uni in NTNU UIO UIB NHH; do
    echo "" > tmp1-${uni}.txt
done

# Extract data from complete year files
for year in 2009 2010 2011 2012 2013 2014 2015; do
    sed -n '/Norges teknisk/,/^$/p' data/${year}.txt >> tmp1-NTNU.txt
    sed -n '/Universitetet i Oslo/,/^$/p' data/${year}.txt >> tmp1-UIO.txt
    sed -n '/Universitetet i Bergen/,/^$/p' data/${year}.txt >> tmp1-UIB.txt
    sed -n '/Norges Handelshøyskole/,/^$/p' data/${year}.txt >> tmp1-NHH.txt
done

# Extract programme IDs and names
function extract {
    # $1 = interval 1
    # $2 = interval 2
    # $3 = interval 3
    # $4 = university
    cut -c "$1" tmp1-"$4".txt > tmp-"$4"-1.txt
    cut -c "$2" tmp1-"$4".txt |
    tr ',' ':' > tmp-"$4"-2.txt
    cut -c "$3" tmp1-"$4".txt |
    tr -s ' ' > tmp-"$4".txt
    paste -d ',' tmp-"$4"-1.txt tmp-"$4"-2.txt > tmp-"$4"-studies-IDs.txt
}

# NTNU
university=NTNU
interval1="6-11"; interval2="13-62"; interval3="6-12,92-96,110-116"
extract ${interval1} ${interval2} ${interval3} ${university}

# UIO
university=UIO
interval1="5-10"; interval2="12-63"; interval3="5-11,82-87,93-96"
extract ${interval1} ${interval2} ${interval3} ${university}

# UIB
university=UIB
interval1="5-10"; interval2="12-63"; interval3="5-11,92-96,102-106"
extract ${interval1} ${interval2} ${interval3} ${university}

# NHH
university=NHH
interval1="5-10"; interval2="12-63"; interval3="5-11,82-86,92-96"
extract ${interval1} ${interval2} ${interval3} ${university}

# Create directory if it does not exist
mkdir -p processed/ordinary
mkdir -p processed/first

# Process data from all universities
for uni in UIO NTNU UIB NHH; do
    awk -f utils/scorelines.awk tmp-${uni}.txt | # Keep lines with actual scores
    sort -s -n -k 1,1 |                 # Sort by study ID; keep year order
    python utils/7lines.py |            # Keep those IDs with scores all 7 years
    tr ' ' ',' |                        # Replace spaces with commas
    awk -F ',' -f utils/gather.awk |    # Gather all 7 scores for ID on one line
    tr ' ' ',' > tmp.csv                # Replace spaces with commas

    # Split into two separate files, one for ordinary quota, one for the other
    awk 'NR % 2 == 1' tmp.csv > tmp-${uni}-ORD.csv
    awk 'NR % 2 == 0' tmp.csv > tmp-${uni}-FORST.csv

    # Add programme names and universities
    python utils/append_titles.py tmp-${uni}-ORD.csv processed/ordinary/${uni}.csv tmp-${uni}-studies-IDs.txt ${uni}
    python utils/append_titles.py tmp-${uni}-FORST.csv processed/first/${uni}.csv tmp-${uni}-studies-IDs.txt ${uni}
    #      utils/append_titles.py [file w/o names] [outfile] [file w/names] [uni]
done

# Cleanup
rm tmp*
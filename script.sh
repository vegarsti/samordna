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
for uni in NTNU UIO UIB NHH Harald HIB PHS; do
    echo "" > tmp1-${uni}.txt
done

# Extract data from complete year files into university files
for year in 2009 2010 2011 2012 2013 2014 2015; do
    sed -n '/Norges teknisk/,/^$/p' data/${year}.txt >> tmp1-NTNU.txt
    sed -n '/Universitetet i Oslo/,/^$/p' data/${year}.txt >> tmp1-UIO.txt
    sed -n '/Universitetet i Bergen/,/^$/p' data/${year}.txt >> tmp1-UIB.txt
    sed -n '/Norges Handelshøyskole/,/^$/p' data/${year}.txt >> tmp1-NHH.txt
    sed -n '/Haraldsplass/,/^$/p' data/${year}.txt >> tmp1-Harald.txt
    sed -n '/Høgskolen i Bergen/,/^$/p' data/${year}.txt >> tmp1-HIB.txt
    sed -n '/Politihøgskolen/,/^$/p' data/${year}.txt >> tmp1-PHS.txt
done

# Extract from university files
function extract {
    int1="$1" # interval 1
    int2="$2" # interval 2
    int3="$3" # interval 3
    uni="$4"  # university

    # Extract IDs and programme names
    cut -c $int1 tmp1-$uni.txt > tmp-$uni-1.txt
    cut -c $int2 tmp1-$uni.txt |
    tr ',' ':' > tmp-$uni-2.txt
    paste -d ',' tmp-$uni-1.txt tmp-$uni-2.txt > tmp-$uni-studies-IDs.txt

    # Extract IDs and scores
    cut -c $int3 tmp1-$uni.txt |
    tr -s ' ' > tmp-$uni.txt
}


# Arguments needed from universities

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

# Haraldsplass
university=Harald
interval1="5-10"; interval2="12-40"; interval3="5-11,82-86,92-96"
extract ${interval1} ${interval2} ${interval3} ${university}

# HiBergen
university=HIB
interval1="5-10"; interval2="12-63"; interval3="5-11,92-96,111-116"
extract ${interval1} ${interval2} ${interval3} ${university}

# Politihøgskolen
university=PHS
interval1="5-10"; interval2="12-41"; interval3="5-11,64-67,72-77"
extract ${interval1} ${interval2} ${interval3} ${university}


# Create directories if they don't exist
mkdir -p processed/ordinary
mkdir -p processed/first


# Process data from all universities
for uni in  UIO NTNU UIB NHH Harald HIB PHS; do
    
    # Variables (for file names)
    infile=tmp-$uni.txt
    tmp1=tmp.csv
    tmp2=tmp-$uni-ORD.csv
    tmp3=tmp-$uni-FORST.csv
    studies=tmp-$uni-studies-IDs.txt

    awk -f utils/scorelines.awk ${infile} | # Keep lines with actual scores
    sort -s -n -k 1,1 |                     # Sort by study ID; keep year order
    python utils/7lines.py |                # Keep those IDs with scores all 7 years
    tr ' ' ',' |                            # Replace spaces with commas
    awk -F ',' -f utils/gather.awk |        # Gather all 7 scores for ID on one line
    tr ' ' ',' > $tmp1                      # Replace spaces with commas

    # Split into two separate files, one for ordinary quota, one for the other
    awk 'NR % 2 == 1' $tmp1 > $tmp2
    awk 'NR % 2 == 0' $tmp1 > $tmp3

    # Add programme names and universities
    python utils/append_titles.py $tmp2 processed/ordinary/$uni.csv $studies $uni
    python utils/append_titles.py $tmp3 processed/first/$uni.csv $studies $uni
    #      utils/append_titles.py [file w/o names] [outfile] [file w/names] [uni]
done

# Cleanup
rm tmp*
rm processed/first/PHS.csv # not first quota...

# Gather all data into one file
for type in first ordinary; do
    # Delete file if it exists; ensures appending (>>) to an empty file below
    if [ -f processed/$type/all.csv ]; then
        rm processed/$type/all.csv
    fi

    # Gather
    files=processed/$type/*
    for file in $files; do
        sed '1d' $file >> processed/$type/all.csv
    done
done
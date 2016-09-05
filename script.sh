#!/bin/sh

# Ensure empty files (only necessary if last run crashed, really)
for uni in NTNU UIO UIB NHH Haraldsplass HIB PHS; do
    echo "" > tmp1-${uni}.txt
done

# Extract data from complete year files into university files
for year in 2009 2010 2011 2012 2013 2014 2015; do
    sed -n '/Norges teknisk/,/^$/p' data/${year}.txt >> tmp1-NTNU.txt
    sed -n '/Universitetet i Oslo/,/^$/p' data/${year}.txt >> tmp1-UIO.txt
    sed -n '/Universitetet i Bergen/,/^$/p' data/${year}.txt >> tmp1-UIB.txt
    sed -n '/Norges Handelshøyskole/,/^$/p' data/${year}.txt >> tmp1-NHH.txt
    sed -n '/Haraldsplass/,/^$/p' data/${year}.txt >> tmp1-Haraldsplass.txt
    sed -n '/Høgskolen i Bergen/,/^$/p' data/${year}.txt >> tmp1-HIB.txt
    sed -n '/Politihøgskolen/,/^$/p' data/${year}.txt >> tmp1-PHS.txt
done

# Function for extracting from university files
function extract {
    int1="$1" # interval 1
    int2="$2" # interval 2
    int3="$3" # interval 3
    uni="$4"  # university

    # Extract IDs and programme names
    cut -c $int1 tmp1-$uni.txt > tmp-$uni-1.txt
    cut -c $int2 tmp1-$uni.txt |
    tr ',' ':' > tmp-$uni-2.txt # turn commas into colons
    paste -d ',' tmp-$uni-1.txt tmp-$uni-2.txt > tmp-$uni-studies-IDs.txt

    # Extract IDs and scores
    cut -c $int3 tmp1-$uni.txt |
    tr -s ' ' > tmp-$uni.txt # turns any number of spaces into one space
}


# Arguments needed from universities
uni[1]=NTNU;    int1[1]="6-11";   int2[1]="13-62"; int3[1]="6-12,92-96,110-116"
uni[2]=UIO;     int1[2]="5-10";   int2[2]="12-63"; int3[2]="5-11,82-87,93-96"
uni[3]=UIB;     int1[3]="5-10";   int2[3]="12-63"; int3[3]="5-11,92-96,102-106"
uni[4]=NHH;     int1[4]="5-10";   int2[4]="12-63"; int3[4]="5-11,82-86,92-96"
uni[5]=Haraldsplass;  int1[5]="5-10";   int2[5]="12-40"; int3[5]="5-11,82-86,92-96"
uni[6]=HIB;     int1[6]="5-10";   int2[6]="12-63"; int3[6]="5-11,92-96,111-116"
uni[7]=PHS;     int1[7]="5-10";   int2[7]="12-41"; int3[7]="5-11,64-67,72-77"

# Extract from universities
for i in {1..7}
do
    extract ${int1[i]} ${int2[i]} ${int3[i]} ${uni[i]}
done


# Create directories (and delete existing ones)
rm -rf processed
mkdir -p processed/ordinary
mkdir -p processed/first


# Process data from all universities
for uni in  UIO NTNU UIB NHH Haraldsplass HIB PHS; do
    
    # Variables (for file names)
    infile=tmp-$uni.txt
    tmp1=tmp.csv
    tmp2=tmp-$uni-ORD.csv
    tmp3=tmp-$uni-FORST.csv
    studies=tmp-$uni-studies-IDs.txt

    awk -f src/scorelines.awk ${infile} |   # Keep lines with actual scores
    sort -s -n -k 1,1 |                     # Sort by study ID; keep year order
    python src/7lines.py |                  # Keep those IDs with scores all 7 years
    tr ' ' ',' |                            # Replace spaces with commas
    awk -F ',' -f src/gather.awk |          # Gather all 7 scores for ID on one line
    tr ' ' ',' > $tmp1                      # Replace spaces with commas

    # Split into two separate files, one for ordinary quota, one for the other
    awk 'NR % 2 == 1' $tmp1 > $tmp2
    awk 'NR % 2 == 0' $tmp1 > $tmp3

    # Add programme names and universities
    python src/append_titles.py $tmp2 processed/ordinary/$uni.csv $studies $uni
    python src/append_titles.py $tmp3 processed/first/$uni.csv $studies $uni
    #      src/append_titles.py [file w/o names] [outfile] [file w/names] [uni]
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
        sed '0d' $file >> processed/$type/all.csv
    done

    # Add headers
    echo 'Programme,2009,2010,2011,2012,2013,2014,2015' |
        cat - processed/$type/all.csv > tmp0 && mv tmp0 processed/$type/all.csv

    # Create file in plot format
    python src/to_plot_format.py processed/$type/all.csv processed/$type/all_plot_format.csv

done
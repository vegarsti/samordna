#!/bin/sh

# Necessary files:
# data/
#   - NTNU.txt
#   - UIO.txt
# utils/
#   - scorelines.awk
#   - 7lines.py
#   - gather.awk

# Create directory if it does not exist
mkdir -p processed

# Extract study ID and name
cut -c 6-11 data/NTNU.txt > tmp1.txt
cut -c 13-62 data/NTNU.txt |
tr ',' ':' > tmp2.txt
paste -d ',' tmp1.txt tmp2.txt > data/studies.txt
rm tmp*.txt

# Extract necessary info from files; only thing different between the two.
cut -c 5-11,83-87,93-96 data/UIO.txt > UIO-tmp.txt
cut -c 6-12,93-97,113-116 data/NTNU.txt > NTNU-tmp.txt

# Process data from both universities
for UNIVERSITY in NTNU; do #UiO NTNU; do
    cat ${UNIVERSITY}-tmp.txt |
    awk -f utils/scorelines.awk |
    sort -s -n -k 1,1 |
    python utils/7lines.py | # or awk -f utils/6lines.awk
    tr ' ' ',' |
    awk -F ',' -f utils/gather.awk |
    tr ' ' ',' > tmp.csv

    # Split into the two separate files
    awk 'NR % 2 == 1' tmp.csv > processed/${UNIVERSITY}-ORD.csv
    awk 'NR % 2 == 0' tmp.csv > processed/${UNIVERSITY}-FORST.csv

    # Connect studies with their name
    cat data/studies.txt |
    python utils/studies_IDs.py > out.txt

    rm tmp.csv ${UNIVERSITY}-tmp.txt
done
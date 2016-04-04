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

# Extract study ID and name from NTNU
cut -c 6-11 data/NTNU.txt > tmp1.txt
cut -c 13-62 data/NTNU.txt |
tr ',' ':' > tmp2.txt
paste -d ',' tmp1.txt tmp2.txt > NTNU-studies-IDs.txt

# Extract study ID and name from UIO
cut -c 5-10 data/UIO.txt > tmp1.txt
cut -c 12-63 data/UIO.txt |
tr ',' ':' > tmp2.txt
paste -d ',' tmp1.txt tmp2.txt > UIO-studies-IDs.txt

# Extract necessary info from files; only thing different between the two.
cut -c 5-11,83-87,93-96 data/UIO.txt > tmp-UIO.txt
cut -c 6-12,93-97,113-116 data/NTNU.txt > tmp-NTNU.txt

# Process data from both universities
for UNIVERSITY in UiO NTNU; do
    cat tmp-${UNIVERSITY}.txt |
    awk -f utils/scorelines.awk |
    sort -s -n -k 1,1 |
    python utils/7lines.py | # or awk -f utils/6lines.awk
    tr ' ' ',' |
    awk -F ',' -f utils/gather.awk |
    tr ' ' ',' > tmp.csv

    # Split into the two separate files, one for ordinary, one for first
    awk 'NR % 2 == 1' tmp.csv > tmp-${UNIVERSITY}-ORD.csv
    awk 'NR % 2 == 0' tmp.csv > tmp-${UNIVERSITY}-FORST.csv

    # Add programme names
    python utils/append_title.py tmp-${UNIVERSITY}-ORD.csv processed/${UNIVERSITY}-ORD.csv ${UNIVERSITY}-studies-IDs.txt
    python utils/append_title.py tmp-${UNIVERSITY}-FORST.csv processed/${UNIVERSITY}-FORST.csv ${UNIVERSITY}-studies-IDs.txt
done

# Cleanup
rm tmp*
rm *-studies-IDs.txt
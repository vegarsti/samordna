#!/bin/sh

# Necessary files:

# In data/
#   - NTNU.txt
#   - UIO.txt
# In utils/
#   - clean.awk
#   - clean.py
#   - gather.awk

# Create directory if it does not exist
mkdir -p processed

# UiO
cut -c 5-11,83-87,93-96 data/UIO.txt |
awk -f utils/scorelines.awk |
sort -s -n -k 1,1 |
python utils/6lines.py |
tr ' ' ',' |
awk -F ',' -f utils/gather.awk |
tr ' ' ',' > tmp.csv

awk 'NR % 2 == 1' tmp.csv > processed/UiO-ORD.csv
awk 'NR % 2 == 0' tmp.csv > processed/UiO-FORST.csv
rm tmp.csv


# NTNU
cut -c 6-12,93-97,113-116 data/NTNU.txt |
awk -f utils/scorelines.awk |
sort -s -n -k 1,1 |
python utils/6lines.py |
tr ' ' ',' |
awk -F ',' -f utils/gather.awk |
tr ' ' ',' > tmp.csv

awk 'NR % 2 == 1' tmp.csv > processed/NTNU-ORD.csv
awk 'NR % 2 == 0' tmp.csv > processed/NTNU-FORST.csv
rm tmp.csv
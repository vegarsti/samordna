import csv
import sys

infile = sys.argv[1]
outfile = sys.argv[2]
database = sys.argv[3]

studies_dict = {}

lines = list(open(database))

for line in lines:
    ID, name = line.split(',')
    name = name.strip() # remove newline chars
    studies_dict[ID] = name

with open(infile, 'r') as csvinput:
    with open(outfile, 'w') as csvoutput:
        reader = csv.reader(csvinput)
        writer = csv.writer(csvoutput, lineterminator='\n')

        document = []
        document.append(['ID', 'Name', 2009, 2010, 2011, 2012, 2013, 2014, 2015])

        for i, row in enumerate(reader):
            ID = row[0]
            name = studies_dict[ID]
            row.insert(1, name)
            document.append(row)

        writer.writerows(document)
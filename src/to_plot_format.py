"""
Given a file in format

Programme,2009 score,2010 score,2011 score,...,2015 score


Creates file of format

Programme,2009,score
Programme,2010,score
Programme,2011,score
...
Programme,2015,score
"""

import csv
import sys

_, infile, outfile = sys.argv

lines = list(open(infile))


with open(infile, 'r') as csvinput:
    with open(outfile, 'w') as csvoutput:
        reader = csv.reader(csvinput)
        writer = csv.writer(csvoutput, lineterminator='\n')

        # Skip header
        next(reader, None)

        document = [['Programme', 'year', 'score']]

        for i, row in enumerate(reader):
            programme, y2009, y2010, y2011, y2012, y2013, y2014, y2015 = row
            for year in range(2009, 2016):
                document.append([programme, year, eval('y' + str(year))])

        writer.writerows(document)


"""
Original format

Programme,2009 score,2010 score,2011 score,...,2015 score

Goal format

Programme,2009,score
Programme,2010,score
Programme,2011,score
...
Programme,2015,score
"""
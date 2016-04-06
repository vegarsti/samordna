# Write (to stdout) lines corresponding to programs
# with 7 years worth of scores

import sys

minimum = 7
buff = []
count = 0
first = ''

lines = sys.stdin.readlines()

for line in lines:
    if line.split()[0] == first:
        count += 1
    else:
        if count == minimum:
            for line in buff:
                sys.stdout.write(line)
        buff = []
        count = 1
    first = line.split()[0]
    buff.append(line)
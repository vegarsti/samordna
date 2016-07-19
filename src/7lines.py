# Write (to stdout) lines corresponding to programs
# with 7 years worth of scores

import sys

amount = 7
buff = []
count = 0
first = ''

lines = sys.stdin.readlines()

def flush(buff):
    for line in buff:
        sys.stdout.write((' ').join(line))
        sys.stdout.write('\n')
    buff = []
    return buff

for line in lines:
    line = line.split()[:3] # ensure no extra stuff
    if line[0] == first:
        count += 1
        buff.append(line)
        if count == amount:
            buff = flush(buff)
    else:
        if count == amount:
            buff = flush(buff)
        buff = []
        count = 1
        buff.append(line)
    first = line[0]
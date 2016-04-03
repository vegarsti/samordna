import sys
lines = sys.stdin.readlines()

studies_dict = {}

for line in lines:
    ID, name = line.split(',')
    name = name.strip() # remove newline chars
    sys.stdout.write("%s %s\n" % (ID, name))
import sys

floor = 0
off = 0

for line in sys.stdin:
    for byte in line:
        if byte == "(":
            floor += 1
            off += 1
        elif byte == ")":
            floor -= 1
            off += 1

        if floor == -1:
            print "at basement, offset:", off

print floor


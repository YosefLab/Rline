import sys

f = open(sys.argv[1], "r")
w = open(sys.argv[2], "w")

for line in f.readlines():
    words = line.split()
    src = words[1]
    print(words)
    for i in range(1, len(words)):
        w.write("{0} {1} 1\n".format(src, words[i]))
        

from TextStore import Token
from TextStore import LineStore

def sort_line(line):
    return line.getY1()

def gatherStatistics(linelist, wordlist):
    linelist = sorted(linelist, key = sort_line)
    max = len(linelist) -1
    i = 0
    current =  linelist[0]
    for word in wordlist:
        if word.getYCoord() <= current.getY2() and word.getYCoord >= current.getY1():
            if word.getXCoord() <= current.getX2() and word.getXCoord >= current.getX1():
                word.incrCount()
        elif current.getY1() > word.getYCoord():
            continue
        elif word.getYCoord() > current.getY1():
            if i < max:
                i+=1
                current = current[i]
        else:
            break
    return wordlist

            

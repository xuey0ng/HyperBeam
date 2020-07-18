import pdf_highlights.TextStore
from pdf_highlights.TextStore import Token
from pdf_highlights.TextStore import LineStore
from pdf_highlights.PDFpos import PDFpos
from pdf_highlights.GetHighlights import Highlights
import json

class Statistics:

    # Function for sorting the positions of the highlight lines from the top to the bottom
    def sort_line(self, line):
        return line.getY1()

    # Function for updating existing statistics
    def gatherStatistics(self, linelist, wordlist):
        linelist = sorted(linelist, key = self.sort_line, reverse = True)
        max = len(linelist) -1
        i = 0
        j = 0
        if max > -1:
            current =  linelist[0]
            maxword = len(wordlist)
            while j < maxword: 
                word = wordlist[j]
                #print("word: " + str(word.getYCoord()) + " | " + str(word.getXCoord()) + " | " + word.getContent())
                #print("line: " + str(current.getY1()) + " | " + str(current.getY2()) + " | " + str(current.getX1()) + " | " + str(current.getX2()) )
                # " | " +  current.getContent())
                if word.getYCoord() <= current.getY1() and word.getYCoord() >= current.getY2():
                    if word.getXCoord() <= current.getX2() and word.getXCoord() >= current.getX1():
                        word.incrCount()
                    j += 1
                elif word.getYCoord() < current.getY2():
                    if i < max:
                        i+=1
                        current = linelist[i]
                    else: 
                        j+=1
                else:
                    j += 1
        return wordlist


    # Function that computes the number of highlights for a NEW pdf. Basefile and infile are often the same
    def compute(self, basefile, infile):
        position_list = PDFpos(basefile)
        position_list = position_list.parsepdf()
        #print(len(position_list))
        student_upload = Highlights()
        student_upload = student_upload.main(infile)
        #print(len(student_upload))
        new_stats = self.gatherStatistics(student_upload, position_list)
        for word in new_stats:
            continue
            print(str(word.getCount()) + " | " + word.getContent())
        return new_stats
    
    
    # class StatisticsEncoder(JSONEncoder):
    #     def default(self, o):
    #         return o.__dict__


# class StatisticsEncoder(JSONEncoder):
#         def default(self, o):
#             return o.__dict__

# current = Statistics()
# current.compute('./pdf_highlights/FinancialAccounting1.pdf', './pdf_highlights/FinancialAccounting1.pdf')
#print(StatisticsEncoder.encode(current))
        

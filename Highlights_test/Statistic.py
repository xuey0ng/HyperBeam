import TextStore
from TextStore import Token
from TextStore import LineStore
from PDFpos import PDFpos
from GetHighlights import Highlights
import json

class Statistics:

    # Function for sorting the positions of the highlight lines from the top to the bottom
    def sort_line(self, line):
        return line.getY1()
    
    def sort_word_page(self, words):
        return words.getPage()
    
    def sort_word_coords(self, words):
        return words.getY2()

    # Function for updating existing statistics
    def gatherStatistics(self, linelist, wordlist):
        # linelist = sorted(linelist, key = self.sort_line, reverse = True)
        wordlist = sorted(wordlist, key = self.sort_word_coords, reverse = True)
        wordlist = sorted(wordlist, key = self.sort_word_page)
        max = len(linelist) -1
        i = 0
        j = 0
        k = 0
        if max > -1:
            current =  linelist[0]
            maxword = len(wordlist)
            while j < maxword: 
                word = wordlist[j]
                # if k<300:
                #     k+=1
                #     print("word: " + str(word.getY1()) + " | " + str(word.getX1()) + " | " + word.getContent())
                #     print("line: " + str(current.getY1()) + " | " + str(current.getY2()) + " | " + str(current.getX1()) + " | " + str(current.getX2()) )
                # " | " +  current.getContent())
                if word.getY2() <= current.getY1() and word.getY2() >= current.getY2():
                    word_x = (word.getX1() + word.getX2())/2
                    if word_x <= current.getX2() and word_x >= current.getX1():
                        word.incrCount()
                        j += 1
                    elif word_x > current.getX2():
                        if (i<max):
                            i += 1
                            current = linelist[i]
                        else:
                            j += 1
                    else:
                        j += 1
                elif word.getPage() > current.getPage():
                    if (i < max):
                        i+=1
                        current = linelist[i]   
                    else:
                        j+=1
                elif word.getY2() < current.getY2():
                    if (i < max and word.getPage() == current.getPage()):
                        i+=1
                        current = linelist[i]
                        # print('b')
                        # print("word: " + str(word.getY2()) + " | " + str(word.getX2()) + " | " + word.getContent() + " | " + str(word.getPage()))
                        # print("line: " +  str(current.getY2()) + " | " + str(current.getX2()) + ' | ' + current.getContent()+ " | " + str(current.getPage()))
                    else: 
                        j+=1
                else:
                    j += 1
        return wordlist


    # Function that computes the number of highlights for a NEW pdf. Basefile and infile are often the same
    def compute(self, basefile, infile):
        position_list = PDFpos(basefile)
        position_list = position_list.parsepdf()
        # print('position list len is {}'.format(len(position_list)))
        student_upload = Highlights()
        student_upload = student_upload.main(infile)
        # print(len(student_upload))
        new_stats = self.gatherStatistics(student_upload, position_list)
        # for word in new_stats:
        #     print(str(word.getCount()) + " | " + word.getContent() + ' | ' + str(word.getY2()))
        # for i in range(300):
        #     word = new_stats[i]
        #     print(str(word.getCount()) + " | " + word.getContent() + ' | ' + str(word.getY2()))
        return new_stats
    
    
    # class StatisticsEncoder(JSONEncoder):
    #     def default(self, o):
    #         return o.__dict__


# class StatisticsEncoder(JSONEncoder):
#         def default(self, o):
#             return o.__dict__

current = Statistics()
current.compute('gw/test2.pdf', 'gw/test2.pdf')
#print(StatisticsEncoder.encode(current))
        

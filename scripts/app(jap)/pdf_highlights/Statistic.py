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
    
    def sort_word_page(self, words):
        return words.getPage()
    
    def sort_word_coords(self, words):
        return words.getY2()

    # Function for updating existing statistics
    def gatherStatistics(self, linelist, wordlist):
        # linelist = sorted(linelist, key = self.sort_line, reverse = True)
        # Sorting of highlight lines moved to GetHighlights

        # First sorts the list of word positions by y-coordinates, before sorting by page
        wordlist = sorted(wordlist, key = self.sort_word_coords, reverse = True)
        wordlist = sorted(wordlist, key = self.sort_word_page)
        max = len(linelist) -1
        i = 0
        j = 0
        if max > -1:
            current =  linelist[0]
            maxword = len(wordlist)
            while j < maxword: 
                word = wordlist[j]
<<<<<<< HEAD:scripts/app(jap)/pdf_highlights/Statistic.py
                if word.getY2() <= current.getY1() and word.getY2() >= current.getY2():
                    word_x = (word.getX1() + word.getX2())/2
                    if word_x <= current.getX2() and word_x >= current.getX1():
                        word.incrCount()
                    j += 1
                elif word.getPage() > current.getPage():
                    if (i < max):
                        i+=1
                        current = linelist[i]   
                    else:
                        j+=1
                elif word.getY2() < current.getY2():
                    if (i < max and word.getPage() == current.getPage()):
=======
                #print("word: " + str(word.getYCoord()) + " | " + str(word.getXCoord()) + " | " + word.getContent())
                #print("line: " + str(current.getY1()) + " | " + str(current.getY2()) + " | " + str(current.getX1()) + " | " + str(current.getX2()) )
                # " | " +  current.getContent())
                if word.getYCoord() <= current.getY1() and word.getYCoord() >= current.getY2():
                    if word.getXCoord() <= current.getX2() and word.getXCoord() >= current.getX1():
                        word.incrCount()
                    j += 1
                elif word.getYCoord() < current.getY2():
                    if i < max:
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3:scripts/app/pdf_highlights/Statistic.py
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
        student_upload = Highlights()
        student_upload = student_upload.main(infile)
        new_stats = self.gatherStatistics(student_upload, position_list)
        return new_stats
    


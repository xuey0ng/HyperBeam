import logging
import os
from firebase_admin import credentials
from google.cloud import firestore, storage
from Statistic import Statistics
from TextStore import Token
from PDFpos import PDFpos
from MasterPDF import GenerateMaster

class AnyHighlights:
    
    def highlights_test(self, infile):
        # Obtains the current working directory in order to create a temporary folder within the container
        this = os.getcwd()

        current = Statistics()
        current_list = current.compute(infile, infile)

        print("Highlights processed")
        # print(len(current_list))
        if len(current_list) > 0:
            filename = str(current_list[0].getHashed())
        else:
            return     
    
        master_pdf = GenerateMaster()
        master_pdf.main(infile, current_list, 1)


        print("master file has been processed")
        # os.remove(temp) 
 
tester = AnyHighlights()
tester.highlights_test("test.pdf")
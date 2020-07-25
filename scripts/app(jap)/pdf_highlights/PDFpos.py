from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdfpage import PDFPage
from pdfminer.pdfpage import PDFTextExtractionNotAllowed
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfdevice import PDFDevice
from pdfminer.layout import LAParams
from pdfminer.converter import PDFPageAggregator
# from pdfminer.high_level import extract_pages
import hashlib
import pdfminer
from pdf_highlights.TextStore import Token

## Program returns the an array containing all of the coords of the pdf to be preprocessed


class PDFpos:
    
    def __init__(self, filename):
        self.word_array = list()
        self.filename = filename
        self.hashed = ''
        self.current = ""
        self.x1 = -1
        self.x2 = -1
        self.y1 = -1
        self.y2 = -1
        self.pageno = -1

    def parse_page(self, lt_page, pageno):
        # loop over the object list
        for obj in lt_page:
            if isinstance(obj, pdfminer.layout.LTTextLine):
                self.parse_line(obj, pageno)

            # if it's a textbox, also recurse
            if isinstance(obj, pdfminer.layout.LTTextBoxHorizontal) or isinstance(obj, pdfminer.layout.LTTextBox):
                if pageno == 1 or pageno == '1':
                    hash_obj = hashlib.md5(str(obj.get_text()).encode())
                    self.hashed = str(hash_obj.hexdigest())
                self.parse_page(obj._objs, pageno)

            # if it's a container, recurse
            elif isinstance(obj, pdfminer.layout.LTFigure):
                self.parse_page(obj._objs, pageno)
                
            elif isinstance(obj, pdfminer.layout.LTChar):
                self.parse_char(obj, pageno)
    
    def parse_line(self, lt_line, pageno):
        # Allows for recursion if the text is stored in a line
        for obj in lt_line:
            if isinstance(obj, pdfminer.layout.LTChar)  and not isinstance(obj, pdfminer.layout.LTAnno):
                self.parse_char(obj, pageno)

    def parse_char(self, obj, pageno):
        if pageno != self.pageno:
            if self.x1 != -1:
                temp = Token(self.pageno, self.x1, self.x2, self.y1, self.y2, self.current, self.filename, self.hashed)
                self.word_array.append(temp)
                self.current = ""
            self.x1 = -1
            self.x2 = -1
            self.y1 = -1
            self.y2 = -1
            self.pageno = -1
        thisword = obj.get_text()
        if thisword == '\n' or thisword == ' ' or thisword == '.' or thisword == ',' or thisword == '—' or thisword == '-':
            if self.x1 != -1:
                temp = Token(self.pageno, self.x1, self.x2, self.y1, self.y2, self.current, self.filename, self.hashed)
                self.word_array.append(temp)
            self.current = ""
            self.x1 = -1
            self.x2 = -1
            self.y1 = -1
            self.y2 = -1
            self.pageno = -1
        elif self.x1 == -1:
            self.x1 = obj.bbox[0]
            self.x2 = obj.bbox[2]
            self.y1 = obj.bbox[1]
            self.y2 = obj.bbox[3]
            self.current += thisword
            self.pageno = pageno
        else:
            self.current += thisword
            self.x2 = obj.bbox[2]
            

    def parsepdf(self):
        # Open a PDF file.
        fp = open(self.filename, 'rb')

        # Create a PDF parser object associated with the file object.
        parser = PDFParser(fp)

        # Create a PDF document object that stores the document structure.
        # Password for initialization as 2nd parameter
        document = PDFDocument(parser)
        # Check if the document allows text extraction. If not, abort.
        if not document.is_extractable:
            print('extraction not allowed')
            raise PDFTextExtractionNotAllowed

        # Create a PDF resource manager object that stores shared resources.
        rsrcmgr = PDFResourceManager()

        # Create a PDF device object.
        device = PDFDevice(rsrcmgr)

        # BEGIN LAYOUT ANALYSIS
        # Set parameters for analysis.
        laparams = LAParams()

        # Create a PDF page aggregator object.
        device = PDFPageAggregator(rsrcmgr, laparams=laparams)

            # Create a PDF interpreter object.
        interpreter = PDFPageInterpreter(rsrcmgr, device)


        i = 0
        # loop over all pages in the 
        for page in PDFPage.create_pages(document):
            # int i to keep track of page numbers
            i+=1

            # read the page into a layout object
            interpreter.process_page(page)
            layout = device.get_result()

            # extract text from this object
            self.parse_page(layout._objs, i)
        return self.word_array
    

#test = PDFpos("FinancialAccounting1.pdf")
#test.parsepdf()
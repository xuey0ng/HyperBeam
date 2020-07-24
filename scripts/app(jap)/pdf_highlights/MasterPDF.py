from PyPDF2 import PdfFileWriter, PdfFileReader
from PyPDF2.generic import DictionaryObject
from PyPDF2.generic import NumberObject
from PyPDF2.generic import FloatObject
from PyPDF2.generic import NameObject
from PyPDF2.generic import TextStringObject
from PyPDF2.generic import ArrayObject
import pdf_highlights.TextStore
import os
from pdf_highlights.TextStore import Token
from pdf_highlights.TextStore import LineStore
from pdf_highlights.PDFpos import PDFpos
from pdf_highlights.GetHighlights import Highlights

class GenerateMaster:

    # Function to generate a new PDF highlight object in accordance to PDF documentation by adobe
    # x1, y1 starts in bottom left corner | color is in the form of RGB
    def createHighlight(self,x1, y1, x2, y2, meta, color = [1, 0, 0]):
        newHighlight = DictionaryObject()

        newHighlight.update({
            NameObject("/F"): NumberObject(4),
            NameObject("/Type"): NameObject("/Annot"),
            NameObject("/Subtype"): NameObject("/Highlight"),

            NameObject("/T"): TextStringObject(meta["author"]),
            NameObject("/Contents"): TextStringObject(meta["contents"]),

            NameObject("/C"): ArrayObject([FloatObject(c) for c in color]),
            NameObject("/Rect"): ArrayObject([
                FloatObject(x1),
                FloatObject(y1),
                FloatObject(x2),
                FloatObject(y2)
            ]),
            NameObject("/QuadPoints"): ArrayObject([
                FloatObject(x1),
                FloatObject(y2),
                FloatObject(x2),
                FloatObject(y2),
                FloatObject(x1),
                FloatObject(y1),
                FloatObject(x2),
                FloatObject(y1)
            ]),
        })

        return newHighlight

    # Function to determine if there is an existing array of annotations, before adding the highlight to the page
    def addHighlightToPage(self,highlight, page, output):
        highlight_ref = output._addObject(highlight)

        if "/Annots" in page:
            page[NameObject("/Annots")].append(highlight_ref)
        else:
            page[NameObject("/Annots")] = ArrayObject([highlight_ref])

    # Main function for processing code that replaces the highlights in a pdf with one of varying shades based
    # on the number of users that have highlighted that specific word
    def main(self, filename, text_array, maxcount):
        # Opens the file specified
        pdfInput = PdfFileReader(open(filename, "rb"))
        pdfOutput = PdfFileWriter()

        # Remove the existing file after processing as PdfFileWriter is unable to overwrite the file
        os.remove(filename)

        # Tranfer every page from the original pdf into the new pdf and remove existing annotations and links
        for page in pdfInput.pages:
            pdfOutput.addPage(page)
        pdfOutput.removeLinks()

        # Based on the information regarding the highlighted pdfs obtained from firebase, highlight with a new shade
        for text in text_array:
            if (text.getCount() >0):

                # Shade is calculated based on RGB, and has to be scaled to support 0 to 1 instead of 0 to 255
                shade = 1 - ((text.getCount() / maxcount)* 220 + 30) / 255
                highlight = self.createHighlight(text.getX1(), text.getY1(), text.getX2(), text.getY2(), {
                    "author": "Hyper-Beam",
                    "contents": text.getContent()
                }, [1, 1, shade])
                
                self.addHighlightToPage(highlight, pdfOutput.getPage(text.getPage()-1), pdfOutput)

        # Outputs the file to the original filename
        outputStream = open(filename, "wb")
        pdfOutput.write(outputStream)
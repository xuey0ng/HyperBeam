from PyPDF2 import PdfFileWriter, PdfFileReader
from PyPDF2.generic import DictionaryObject
from PyPDF2.generic import NumberObject
from PyPDF2.generic import FloatObject
from PyPDF2.generic import NameObject
from PyPDF2.generic import TextStringObject
from PyPDF2.generic import ArrayObject
import pdf_highlights.TextStore
from pdf_highlights.TextStore import Token
from pdf_highlights.TextStore import LineStore
from pdf_highlights.PDFpos import PDFpos
from pdf_highlights.GetHighlights import Highlights

class GenerateMaster:

    # x1, y1 starts in bottom left corner
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

    def addHighlightToPage(self,highlight, page, output):
        highlight_ref = output._addObject(highlight)

        if "/Annots" in page:
            page[NameObject("/Annots")].append(highlight_ref)
        else:
            page[NameObject("/Annots")] = ArrayObject([highlight_ref])

    def main(self, filename, text_array, maxcount):
        pdfInput = PdfFileReader(open(filename, "rb"))
        pdfOutput = PdfFileWriter()

        for page in pdfInput.pages:
            pdfOutput.addPage(page)
        pdfOutput.removeLinks()

        for text in text_array:
            if (text.getCount() >0):
                shade = text.getCount()/maxcount
                highlight = self.createHighlight(text.getX1(), text.getY1(), text.getX2(), text.getY2(), {
                    "author": "Hyper-Beam",
                    "contents": text.getContent()
                }, [shade, shade, 0])
                self.addHighlightToPage(highlight, pdfOutput.getPage(text.getPage()-1), pdfOutput)

        outputStream = open(filename, "wb")
        pdfOutput.write(outputStream)
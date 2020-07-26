import sys
import PyQt5
import popplerqt5
from pdf_highlights.TextStore import LineStore

## Program returns a list of LineStore objects, an object that stores all the words in a highlight and its coordinates

class Highlights:
    resolution = 150

    # Sorts the highlight annotations by their position. If the annotation is not a highlight annotation, place at the top.
    def sort_anno(self, anno):
        if isinstance(anno, popplerqt5.Poppler.HighlightAnnotation):
            return anno.highlightQuads()[0].points[0].y()
        return 800

    def main(self, infile):

        doc = popplerqt5.Poppler.Document.load(infile)
        total_annotations = 0
        linelist = list()
        for i in range(doc.numPages()):
            # print("========= PAGE {} =========".format(i+1))
            page = doc.page(i)
            annotations = page.annotations()
            
            (pwidth, pheight) = (page.pageSize().width(), page.pageSize().height())
            #print(pwidth)
            #print(pheight)
            count = 0

            if len(annotations) > 0:
                ##print(annotations)
                annotations = sorted(annotations, key = self.sort_anno)
                for annotation in annotations:

                    if isinstance(annotation, popplerqt5.Poppler.Annotation):
                        total_annotations += 1
                        
                        if (isinstance(annotation, popplerqt5.Poppler.HighlightAnnotation)):
                            quads = annotation.highlightQuads()
                            txt = ""
                            print('a')
                            for quad in quads:
                                print('b')
                                # print(quad.points[0].x()*pwidth)
                                # print(int(pheight - quad.points[0].y()*pheight - 9))
                                rect = (quad.points[0].x() * pwidth,
                                        quad.points[0].y() * pheight,
                                        quad.points[2].x() * pwidth,
                                        quad.points[2].y() * pheight)
                                bdy = PyQt5.QtCore.QRectF()
                                bdy.setCoords(*rect)
                                txt = str(page.text(bdy)) + ' ' ## add each seperately
                                temp = LineStore(i+1, float(quad.points[0].x() * pwidth), float(pheight - quad.points[0].y()*pheight + 3), 
                                float(quad.points[2].x() * pwidth), float(pheight - quad.points[2].y()*pheight - 1), txt)
                                linelist.append(temp)
                                # print(txt)
                            # print("========= ANNOTATION =========")
                            #print(txt)
                            # if annotation.contents():
                            # 	print("\t - {}".format(annotation.contents()))
                            #print(str(quad.points[0].x() * pwidth) + " | "  + str(quad.points[2].x() * pwidth) + " | " +
                            #str(pheight - quad.points[2].y()*pheight + 3) + " | " + str(pheight - quad.points[0].y()*pheight - 1))    
                                                    
                            
                        if isinstance(annotation, popplerqt5.Poppler.GeomAnnotation):
                            count += 1
                            bounds = annotation.boundary()

                            # default we have height/width as per 72p rendering so converting to different resolution
                            (width, height) = (pwidth*resolution/72, pheight*resolution/72)

                            bdy = PyQt5.QtCore.QRectF(
                                bounds.left()*width, 
                                bounds.top()*height, 
                                bounds.width()*width, 
                                bounds.height()*height
                            )
                            
                            page.renderToImage(resolution, resolution, bdy.left(), bdy.top(), bdy.width(), bdy.height()).save("page{}_image{}.png".format(i, count))
                            print("page{}_image{}.png".format(i, count))
                        #    if annotation.contents(): 
                        #         print(annotation.contents())
                            
                        # if isinstance(annotation, popplerqt5.Poppler.TextAnnotation):
                        #     if annotation.contents(): 
                        #         print(annotation.contents())

        if total_annotations > 0:
            print("line list is {}".format(len(linelist)))
            return linelist
        else:
            print ("no annotations found")
            return linelist

    # if __name__ == "__main__":
    #     main()
#test = Highlights()
#test.main('FinancialAccounting1.pdf')
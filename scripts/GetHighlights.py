import popplerqt5
import sys
import PyQt5
from TextStore import LineStore


resolution = 150

def main():

    doc = popplerqt5.Poppler.Document.load(sys.argv[1])
    total_annotations = 0
    linelist = list()
    for i in range(doc.numPages()):
        print("========= PAGE {} =========".format(i+1))
        page = doc.page(i)
        annotations = page.annotations()
        (pwidth, pheight) = (page.pageSize().width(), page.pageSize().height())
        count = 0

        if len(annotations) > 0:
            ##print(annotations)
            for annotation in annotations:

                if isinstance(annotation, popplerqt5.Poppler.Annotation):
                    total_annotations += 1
                    
                    if (isinstance(annotation, popplerqt5.Poppler.HighlightAnnotation)):
                        quads = annotation.highlightQuads()
                        txt = ""
                        for quad in quads:
                            # print(quad.points[0].x()*pwidth)
                            # print(int(pheight - quad.points[0].y()*pheight - 9))
                            rect = (quad.points[0].x() * pwidth,
                                    quad.points[0].y() * pheight,
                                    quad.points[2].x() * pwidth,
                                    quad.points[2].y() * pheight)
                            bdy = PyQt5.QtCore.QRectF()
                            bdy.setCoords(*rect)
                            txt = txt + str(page.text(bdy)) + ' '

                        # print("========= ANNOTATION =========")
                        print(txt)
                        # if annotation.contents():
                        # 	print("\t - {}".format(annotation.contents()))
                            
                        temp = LineStore(i, int(quad.points[0].x() * pwidth), int(pheight - quad.points[0].y()*pheight - 9), 
                        int(quad.points[2].x() * pwidth), int(pheight - quad.points[2].y()*pheight - 9), txt)
                        linelist.append(temp)                        
                        
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
                        if annotation.contents(): 
                        	print(annotation.contents())
                        
                    if isinstance(annotation, popplerqt5.Poppler.TextAnnotation):
                        if annotation.contents(): 
                        	print(annotation.contents())

    if total_annotations > 0:
        print(linelist)
        return linelist
    else:
        print ("no annotations found")

if __name__ == "__main__":
    main()
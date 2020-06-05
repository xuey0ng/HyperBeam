class Token:

    def __init__(self, page, x_coord, y_coord, content): ## x_coord refers to the coordinate of the top left hand corner of the text
        self.x_coord = x_coord
        self.y_coord = y_coord
        self.content = content
        self.page = page
        self.qns = list()  ##qns should be a list of Questions
    
    def getXCoord(self):
        return self.x_coord
        
    def getYCoord(self):
        return self.y_coord

    def getContent(self):
        return self.content

    def addQns(self, question): ##question should be a class that contain the relevant information about that question
        self.qns = self.qns.append(question)

    def getQns(self):
        return self.qns


class LineStore:

    def __init__(self, page, x1, y1, x2, y2, content): ## x_coord refers to the coordinate of the top left hand corner of the text
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
        self.page = page
        self.content = content
    
    def getX1(self):
        return self.x1

    def getX2(self):
        return self.x2

    def getY1(self):
        return self.y1

    def getY2(self):
        return self.y2
    
    def getContent(self):
        return self.content
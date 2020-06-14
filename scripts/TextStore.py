class Token:

    def __init__(self, page, x_coord, y_coord, content, filename): ## x_coord refers to the coordinate of the top left hand corner of the text
        self.x_coord = x_coord
        self.y_coord = y_coord
        self.content = content
        self.page = page
        self.count = 0
        self.qns = list()  ##qns should be a list of Questions
        self.hashstr = str(page).zfill(3) + str(x_coord).zfill(4) + str(y_coord).zfill(3)
        self.hashcode = hash(self.hashstr)
        self.filename = filename
    
    def getPage(self):
        return self.page
    
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
    
    def hashCode(self):
        return self.hashcode
    
    def getCount(self):
        return self.count
    
    def getFilename(self):
        return self.filename
    
    def incrCount(self):
        self.count +=1
    
    @staticmethod
    def from_dict(source):
        return Token(source.get('page'), source.get('x'), source.get('y'), source.get('content'), source.get('filename'))
    
    def to_dict(self):
        return {'page': self.page, 'x' : self.x_coord, 'y' : self.y_coord, 'content' : self.content, 'filename' : self.filename, 'count' : self.getCount}

    def __repr__(self):
        return(
            f'Word(\
                page={self.page}, \
                x_coord={self.x_coord}, \
                y_coord={self.y_coord}, \
                content={self.content}, \
                filename={self.filename}, \
                count={self.count}\
            )'
        )


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
    
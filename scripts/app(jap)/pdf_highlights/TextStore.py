class Token:

    def __init__(self, page, x1, x2, y1, y2, content, filename, hashed): ## x_coord refers to the coordinate of the top left hand corner of the text
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
        self.content = content
        self.page = page
        self.count = 0
        self.qns = list()  ##qns should be a list of Questions
        self.hashstr = str(page).zfill(3) + str((x1+x2)/2).zfill(4) + str(y2).zfill(3)
        self.hashcode = hash(self.hashstr)
        self.filename = filename
        self.hashed = hashed
    
    def getPage(self):
        return self.page
    
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
    
    def setCount(self, count):
        self.count = count

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
    
    def getHashed(self):
        return self.hashed
    
    def incrCount(self):
        self.count +=1
    
    @staticmethod
    def from_dict(source):
        return Token(source[u'page'], source[u'x1'], source[u'x2'], source[u'y1'], source[u'y2'], \
            source[u'content'], source[u'filename'], source[u'hashed'])
    
    def to_dict(self):
        return {u'page': self.page, u'x1' : self.x1, u'x2' : self.x2, u'y1' : self.y1, u'y2' : self.y2, u'content' : self.content, \
            u'filename' : self.filename, u'count' : self.count, u'hashed' : self.hashed}

    # def __repr__(self):
    #     return(
    #         f'Word(\
    #             page={self.page}, \
    #             x_coord={self.x_coord}, \
    #             y_coord={self.y_coord}, \
    #             content={self.content}, \
    #             filename={self.filename}, \
    #             count={self.count}\
    #         )'
    #     )


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
    
    def getPage(self):
        return self.page
    
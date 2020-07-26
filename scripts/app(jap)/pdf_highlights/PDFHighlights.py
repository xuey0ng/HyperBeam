import firebase_admin
import os
import logging
from firebase_admin import credentials, messaging
from google.cloud import firestore, storage
from flask import escape
from pdf_highlights.Statistic import Statistics
from pdf_highlights.TextStore import Token
from pdf_highlights.PDFpos import PDFpos


class PDFhighlights:
    
    # Initialise the firestore and storage instance
    def __init__(self):
        self.db = firestore.Client()
        self.stor = storage.Client()
        # Set the logging for the GAE application
        # logging.basicConfig(format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p', level=logging.DEBUG)

    # Function to create new collection when new pdf is uploaded
    def new_pdf(self, wordlist, filename):
        stats_collection = self.db.collection(u'pdfs').document(filename).collection(u'words')
        stats_collection.document(u'total').set({
            u'count' : 1
        })
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
            current = stats_collection.document(name)
            x = wordstore.to_dict()
            current.set(x)
            #stats_collection.add(wordstore.to_dict())
        

    # Function to update highlights when existing pdf is uploaded
    def update_highlights(self, wordlist, filename):
        stats_collection = self.db.collection(u'pdfs').document(filename).collection(u'words')
        stats_collection.document(u'total').update({u'total' : firestore.Increment(1)})
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
            current = stats_collection.document(name)
<<<<<<< HEAD:scripts/app(jap)/pdf_highlights/PDFHighlights.py
            if current.get().exists:
                current.update({'count' : firestore.Increment(wordstore.getCount())})
            else:
                current.set(wordstore.to_dict())

        # Initialises the list before pulling the updated firebase collection. 
        text_list =  list()
        docs = stats_collection.stream()
        count = 1
        for doc in docs:
            current_doc = doc.to_dict()
            if len(current_doc) > 1:
                text_list.append(Token.from_dict(doc.to_dict()))
                text_list[-1].setCount(current_doc[u'count'])
            else:
                count = current_doc[u'total']
        return text_list, count

    def update_db(self, module, id, user, pdf_name, url):
        # First access the quiz ref
        quiz = self.db.collection('users').document(user).collection('Modules').document(module)
        quiz_col = quiz.get()
        quiz_dict = quiz_col.to_dict()
        quizzes = quiz_dict['quizzes']

        master = self.db.collection('MasterPDFMods').document(module).collection('PDFs').document(id)
        master_col = master.get()
        if master_col.exists:
            # change datetime
            master.update({'lastUpdated' : firestore.SERVER_TIMESTAMP})
        else:
            master.set({'lastUpdated' : firestore.SERVER_TIMESTAMP,
            'PDFName' : id,
            'uri' : url})
        
        # add users
        users = master.collection('Users').document(user)
        users.set({'subscribed' : True,
        'userFileName' : pdf_name,
        'quizzes': quizzes})
=======
            current.update({'count' : firestore.Increment(wordstore.getCount())})
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3:scripts/app/pdf_highlights/PDFHighlights.py
        
    def gen_master(self, filename):
        stats_collection = self.db.collection(u'pdfs').document(filename).collection(u'words')

    # Function to process the newly uploaded file from cloud storage
    def process(self, bucket_name, blob_name):
        # Download the file from gcloud storage into a temporary folder tmp
        bucket = self.stor.bucket(bucket_name)
        blob = bucket.blob(blob_name)
        
        # Obtains the current working directory in order to create a temporary folder within the container
        this = os.getcwd()
        if this[-1] != '/':
            this += '/'
        # May have to move to tmp
        temp = '{}temp/{}'.format(this, blob_name.split('/')[-1])
        check = '{}temp'.format(this)
        if not os.path.isdir(check):
            logging.info('Directory %s is created.', this)
            os.mkdir(check)
        # logging.info('Download {}'.format(temp))
        blob.download_to_filename(temp)
        
        # Process the file and check if pdf exist
        current = Statistics()
        current_list = current.compute(temp, temp)
        if len(current_list) > 0:
            filename = str(current_list[0].getHashed())
        else:
            logging.error('File hash failed')
            return
<<<<<<< HEAD:scripts/app(jap)/pdf_highlights/PDFHighlights.py


        # Check if the document exists
        doc_ref = self.db.collection('pdfs').document(filename).collection(u'words').document(u'total')
        doc = doc_ref.get()
        if doc.exists:
            # logging.info('filename: %s exists', filename)

            # Update the file on the cloud database before generating the master pdf
            text_list, maxcount = self.update_highlights(current_list, filename)
            master_pdf = GenerateMaster()
            master_pdf.main(temp, text_list, maxcount)
        else:   
            # logging.info('filename: %s does not exists, creating new entry', filename)
            # Initialise a new collection for the new pdf upload and generate the corresponding master pdf
=======
        doc_ref = self.db.collection('pdfs').document(filename)
        doc = doc_ref.get()        
        # Insert module to amend the masterlist to correctly reflect the latest highlights
        if doc.exists:
            logging.info('filename: %s exists', filename)
            self.update_highlights(current_list, filename)
            
        else:
            logging.info('filename: %s does not exists\ncreating new entry', filename)
            ## run get pos and initalise
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3:scripts/app/pdf_highlights/PDFHighlights.py
            self.new_pdf(current_list, filename)
            
        # generate and upload pdf from new info [TO DO]
        destination = 'master/{}'.format(filename)
        blob_up = bucket.blob(destination)
        blob_up.upload_from_filename(temp)  
<<<<<<< HEAD:scripts/app(jap)/pdf_highlights/PDFHighlights.py

        # Obtain and upload the link to the master pdf to the directory 
        master_url = blob_up.public_url    
        if master_url == None:
            master_url = ''
        blob_link = bucket.blob(new_url)
        blob_link.upload_from_string(str(master_url))
=======
        master_url = blob_up.public_url      
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3:scripts/app/pdf_highlights/PDFHighlights.py
        os.remove(temp) 

        # Update the MasterPDFMods collection in firestore
        display_name = str(current_list[0].getFilename())
        display_name = display_name.split('/')[-1]
        self.update_db(blob_name.split('/')[2], str(current_list[0].getHashed()), blob_name.split('/')[1], display_name, str(master_url))
        doc_ref = self.db.collection(u'users').document(blob_name.split('/')[1])
        curr = doc_ref.get().to_dict()
        subscribtion_list = list()
        try:
            subscribtion_list.append(curr[u'token'])
            messaging.subscribe_to_topic(subscribtion_list, filename.split('.')[0])
        except:
            logging.error("Token not found")
        return str(master_url) , filename



# test = PDFhighlights()
# test.process("hyper-beam.appspot.com/", "/pdf/tBqBjEWxZiRwGwMk2uzyEaYTNvl1/E2oIm06YtiiYQMbfsJMM/avatar.pdf")
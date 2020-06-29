import firebase_admin
import os
import logging
from firebase_admin import credentials
from google.cloud import firestore, storage
from flask import escape

cred = credentials.Certificate("hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
firebase_admin.initialize_app(cred)

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
        stats_collection.document(u'total').update({u'total' : firestore.transforms.Increment(1)})
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
            current = stats_collection.document(name)
            current.update({'count' : firestore.transforms.Increment(wordstore.getCount())})
        
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
        temp = '{}temp/{}'.format(this, blob_name.split('/')[-1])
        check = '{}temp'.format(this)
        if not os.path.isdir(check):
            logging.info('Directory %s is created.', this)
            os.mkdir(check)
        logging.info('Download {}'.format(temp))
        blob.download_to_filename(temp)
        
        # Process the file and check if pdf exist
        current = Statistics()
        current_list = current.compute(temp, temp)
        if len(current_list) > 0:
            filename = str(current_list[0].getHashed())
        else:
            return
        doc_ref = self.db.collection('pdfs').document(filename)
        doc = doc_ref.get()        
        # Insert module to amend the masterlist to correctly reflect the latest highlights
        if doc.exists:
            logging.info('filename: %s exists', filename)
            self.update_highlights(current_list, filename)
            # generate and upload pdf from new info [TO DO]
            destination = '/master/{}'.format(filename)
            blob_up = bucket.blob(destination)
            blob.upload_from_filename(temp)
        else:
            logging.info('filename: %s does not exists', filename)
            ## run get pos and initalise
            self.new_pdf(current_list, filename)
            destination = '/master/{}'.format(filename)
            blob_up = bucket.blob(destination)
            blob.upload_from_filename(temp)
        # os.remove(temp)





## for new_pdf old code
# if len(wordlist) > 1 :
#         doc = wordlist[0].getFilename()
#         stats_collection = db.collection(u'pdfs').document(doc).collection('words')
#         db.collection.document(u'total').set({
#             u'count' : 1
#         })
#         for wordstore in wordlist:
#             name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
#             current = stats_collection.document(name)
#             current.set({ 
#                 u'page': str(wordstore.getPage()),
#                 u'x' : wordstore.getXCoord(),
#                 u'y': wordstore.getYCoord(),
#                 u'content' : wordstore.getContent(),
#                 u'filename': wordstore.getFilename()
#             })

# test = PDFhighlights()
# test.process("hyper-beam.appspot.com/", "/pdf/tBqBjEWxZiRwGwMk2uzyEaYTNvl1/E2oIm06YtiiYQMbfsJMM/avatar.pdf")
import firebase_admin
import os
import logging
from firebase_admin import credentials
from google.cloud import firestore, storage
from flask import escape
from pdf_highlights.Statistic import Statistics
from pdf_highlights.TextStore import Token
from pdf_highlights.PDFpos import PDFpos
from pdf_highlights.MasterPDF import GenerateMaster


class PDFhighlights:
    
    # Initialise the firestore and storage instance
    def __init__(self):
        self.db = firestore.Client()
        self.stor = storage.Client()

    # Function to create new collection when new pdf is uploaded
    def new_pdf(self, wordlist, filename):
        stats_collection = self.db.collection(u'pdfs').document(filename).collection(u'words')
        stats_collection.document(u'total').set({
            u'total' : 1
        })
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str((wordstore.getX1()+wordstore.getX2())/2) + "_" + str(wordstore.getY2())
            current = stats_collection.document(name)
            x = wordstore.to_dict()
            current.set(x)
            #stats_collection.add(wordstore.to_dict())
        

    # Function to update highlights when existing pdf is uploaded
    def update_highlights(self, wordlist, filename):
        stats_collection = self.db.collection(u'pdfs').document(filename).collection(u'words')
        stats_collection.document(u'total').update({u'total' : firestore.Increment(1)})
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str((wordstore.getX1()+wordstore.getX2())/2) + "_" + str(wordstore.getY2())
            current = stats_collection.document(name)
            current.update({'count' : firestore.Increment(wordstore.getCount())})
        text_list =  list()
        
        docs = stats_collection.stream()
        count = 1
        for doc in docs:
            current_doc = doc.to_dict()
            if len(current_doc) > 1:
                text_list.append(Token.from_dict(doc.to_dict()))
            else:
                count = current_doc[u'total']

        return text_list, count
        

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
        temp = '{}tmp/{}'.format(this, blob_name.split('/')[-1])
        check = '{}tmp'.format(this)
        if not os.path.isdir(check):
            logging.info('Directory %s is created.', check)
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
        doc_ref = self.db.collection('pdfs').document(filename).collection(u'words').document(u'total')
        doc = doc_ref.get()        
        # Insert module to amend the masterlist to correctly reflect the latest highlights
        if doc.exists:
            logging.info('filename: %s exists', filename)
            self.update_highlights(current_list, filename)
            
            text_list, maxcount = self.update_highlights(current_list, filename)
            master_pdf = GenerateMaster()
            master_pdf.main(temp, text_list, maxcount)
        else:
            logging.info('filename: %s does not exists, creating new entry', filename)
            ## run get pos and initalise
            self.new_pdf(current_list, filename)
            master_pdf = GenerateMaster()
            master_pdf.main(temp, current_list, 1)
            
        # generate and upload pdf from new info [TO DO]
        file_len = len(blob_name.split('/')[-1])
        new_url = blob_name[:-file_len]
        new_url += 'link.txt'

        filename = filename + '.pdf'
        destination = 'master/{}'.format(filename)
        blob_up = bucket.blob(destination)
        blob_up.upload_from_filename(temp)  
        master_url = blob_up.public_url    

        blob_link = bucket.blobl(new_url)
        blob_link.upload_from_string(str(master_url))
        os.remove(temp) 



# test = PDFhighlights()
# test.process("hyper-beam.appspot.com/", "/pdf/tBqBjEWxZiRwGwMk2uzyEaYTNvl1/E2oIm06YtiiYQMbfsJMM/avatar.pdf")
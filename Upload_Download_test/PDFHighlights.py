import os
import logging
from flask import escape
import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore, storage

cred = credentials.Certificate("hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
firebase_admin.initialize_app(cred)

class PDFhighlights:
    
    # Initialise the firestore and storage instance
    def __init__(self):
        self.db = firestore.Client()
        self.stor = storage.Client()
        # Set the logging for the GAE application
        # logging.basicConfig(format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p', level=logging.DEBUG)



    # Function to process the newly uploaded file from cloud storage
    def process(self, bucket_name, blob_name):
        # Download the file from gcloud storage into a temporary folder tmp
        bucket = self.stor.bucket(bucket_name)
        blob = bucket.blob(blob_name)
        
        # Obtains the current working directory in order to create a temporary folder within the container
        this = os.getcwd()
        filename = blob_name.split('/')[-1]
        if this[-1] != '/':
            this += '/'
        temp = '{}temp/{}'.format(this, filename)
        check = '{}temp'.format(this)
        if not os.path.isdir(check):
            logging.info('Directory %s is created.', this)
            os.mkdir(check)
        logging.info('Download {}'.format(temp))
        blob.download_to_filename(temp)
        
        print(os.path.isdir(check))
        print(filename)
        print(check)
        print(temp)
        # generate and upload pdf from new info [TO DO]
        bucket = self.stor.get_bucket(bucket_name)
        destination = 'master/{}'.format('FinancialAccounting2.pdf')
        temp = '/mnt/c/Misc/orbital/app_test/Upload_Download_test/temp/FinancialAccounting2.pdf'
        blob_up = bucket.blob(destination)
        blob_up.upload_from_filename(temp)
        print(blob_up.public_url)
        
        # os.remove(temp)
        print('done')





test = PDFhighlights()
test.process("hyper-beam.appspot.com", "pdf/FinancialAccounting1.pdf")
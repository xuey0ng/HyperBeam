import firebase_admin
import os
import logging
import TextStore
from firebase_admin import credentials
from google.cloud import firestore, storage
from flask import escape
from Statistic import Statistics
from TextStore import Token
from PDFpos import PDFpos
from MasterPDF import GenerateMaster

class PDFhighlights:
    
    # Initialise the firestore and storage instance
    def __init__(self):
        self.db = firestore.Client()
        self.stor = storage.Client()
        cred = credentials.Certificate("hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
        firebase_admin.initialize_app(cred)
    
    def update_highlights(self):
        stats_collection = self.db.collection(u'testpdf')
        # stats_collection.document(u'total').set({
        #     u'count' : 1
        # })
        doc = stats_collection.document(u'total').get()
        if doc.exists:
            print('exists1')
        stats_collection.document(u'total').update({u'count' : firestore.Increment(1)})
        doc2 = self.db.collection(u'tester').document('1')
        doc3 = doc2.collection('2').document('test')
        doc3.set({'a' : 1})
        doc4 = doc2.get()
        if doc4.exists:
            print('exists2')
        if doc3.get().exists:
            print('exist4')
        
        print('done')
    
    def download(self, bucket_name, blob_name):
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
            logging.info('Directory %s is created.', this)
            os.mkdir(check)
        logging.info('Download {}'.format(temp))
        blob.download_to_filename(temp)
    
    def update_time(self, module, id, user, pdf_name):
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
            'PDFName' : pdf_name})
        
        # add users
        users = master.collection('Users').document(user)
        users_col = users.get()
        if not users_col.exists:
            users.set({'subscribed' : True,
            'userFileName' : pdf_name})
        users.set({'quizzes' : quizzes})



test = PDFhighlights()
# test.download("hyper-beam.appspot.com", "master/e443ce30f16dc6bddaa6c839f8fcfc81.pdf")
# test.download("hyper-beam.appspot.com",'pdf/tBqBjEWxZiRwGwMk2uzyEaYTNvl1/IqCt9Gxm33fbHxppSy9A/link.txt')
# test.update_highlights()
test.update_time('CS2030', 'thisispdfid', 's7CbPVYl55dxVgG9mSIyKfxw1Vr1', 'test.pdf')
import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore
from flask import escape
from Statistic import Statistics
from TextStore import Token
from PDFpos import PDFpos

cred = credentials.Certificate("hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
firebase_admin.initialize_app(cred, )
db = firestore.Client()

def new_pdf(wordlist):
    if len(wordlist) > 1 :
        doc = wordlist[0].getFilename()
        stats_collection = db.collection(u'pdfs').document(doc).collection(u'words')
        db.collection.document(u'total').set({
            u'count' : 1
        })
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
            current = stats_collection.document(name)
            current.set({wordstore.to_dict()})
            #stats_collection.add(wordstore.to_dict())


def update_highlights(wordlist):
    if len(wordlist) > 1 :
        doc = wordlist[0].getFilename()
        stats_collection = db.collection(u'pdfs').document(doc).collection(u'words')
        db.collection.document(u'total').update({u'total' : firestore.Increment(1)})
        for wordstore in wordlist:
            name = str(wordstore.getPage()) + "_" + str(wordstore.getXCoord()) + "_" + str(wordstore.getYCoord())
            current = stats_collection.document(name)
            current.update({'count' : firestore.Increment(wordstore.getCount())})

def hello_gcs_generic(data, context):
    """Background Cloud Function to be triggered by Cloud Storage.
       This generic function logs relevant data when a file is changed.

    Args:
        data (dict): The Cloud Functions event payload.
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; the output is written to Stackdriver Logging
    """

    # print('Event ID: {}'.format(context.event_id))
    # print('Event type: {}'.format(context.event_type))
    # print('Bucket: {}'.format(data['bucket']))
    # print('File: {}'.format(data['name']))
    # print('Metageneration: {}'.format(data['metageneration']))
    # print('Created: {}'.format(data['timeCreated']))
    # print('Updated: {}'.format(data['updated']))
    doc_ref = db.collection('pdf').document(data['name'])
    doc = doc_ref.get()
    current_list = list()
    if doc.exists:
        doc = db.collection('pdf').document(data['name']).collection('words').get()
        for ele in doc:
            ele.to_dict()
        current = Statistics()
        Statistics.compute(current_list, data['name'])
    else:
        ## run get pos and initalise
        new_pdf = PDFpos()
        





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



# gcloud functions deploy hello_gcs_generic \
# --runtime python37 \
# --trigger-resource YOUR_TRIGGER_BUCKET_NAME \
# --trigger-event google.storage.object.finalize
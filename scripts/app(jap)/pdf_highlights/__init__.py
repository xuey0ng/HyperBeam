import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore, storage

cred = credentials.Certificate("./pdf_highlights/hyperbeam1-7ec13-firebase-adminsdk-6hitn-84f95b3bd1.json")
firebase_admin.initialize_app(cred)
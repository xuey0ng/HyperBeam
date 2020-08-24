import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore, storage

cred = credentials.Certificate("./pdf_highlights/hyperbeam2-c67c0-firebase-adminsdk-qvbju-a891c677a3.json")
firebase_admin.initialize_app(cred)
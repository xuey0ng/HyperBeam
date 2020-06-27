import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore, storage

cred = credentials.Certificate("./pdf_highlights/hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
firebase_admin.initialize_app(cred)
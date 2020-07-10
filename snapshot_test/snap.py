import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore, storage
import threading

cred = credentials.Certificate("hyper-beam-firebase-adminsdk-3t5wg-60d7f00668.json")
firebase_admin.initialize_app(cred)


def listen_document():
    db = firestore.Client()
    # [START listen_document]

    # Create an Event for notifying main thread.
    callback_done = threading.Event()

    # Create a callback on_snapshot function to capture changes
    def on_snapshot(doc_snapshot, changes, read_time):
        for doc in doc_snapshot:
            print(f'Received document snapshot: {doc.id}')
        callback_done.set()

    doc_ref = db.collection(u'cities').document(u'SF')

    # Watch the document
    doc_watch = doc_ref.on_snapshot(on_snapshot)
    # [END listen_document]

    # Creating document
    data = {
        u'name': u'San Francisco',
        u'state': u'CA',
        u'country': u'USA',
        u'capital': False,
        u'population': 860000
    }
    doc_ref.set(data)
    # Wait for the callback.
    callback_done.wait(timeout=60)
    # [START detach_listener]
    # Terminate watch on a document
    doc_watch.unsubscribe()
    # [END detach_listener]
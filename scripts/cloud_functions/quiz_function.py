from datetime import datetime, timedelta
import json
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2
from flask import escape

PROJECT_ID = 'hyperbeam1-7ec13'

cred = credentials.ApplicationDefault()
default_app = firebase_admin.initialize_app(cred, {
'projectId': PROJECT_ID,
})

client = firestore.Client()
tasks = tasks_v2.CloudTasksClient()


# cloud scheduler to call get_updates once per hour
def get_updates(request):

    def make_task(uid, module, quiz, date, quiz_ref=None):
    # Construct the fully qualified queue name.
        project = 'hyperbeam1-7ec13'
        queue = 'hyper-queue'
        location = 'asia-northeast1'
        parent = tasks.queue_path(project, location, queue)

        payload = uid + ',' + module + ',' + quiz 
        if quiz_ref != None:
            payload += ',' + quiz_ref
        # Construct the request body.
        task = {
            'app_engine_http_request': {  # Specify the type of request.
                'http_method': 'POST',
                'relative_uri': '/task_handler'
            }
        }

        # The API expects a payload of type bytes.
        converted_payload = payload.encode()

        # Add the payload to the request.
        task['app_engine_http_request']['body'] = converted_payload


        # Create Timestamp protobuf.
        timestamp = timestamp_pb2.Timestamp()
        timestamp.FromDatetime(date)

        # Add the timestamp to the tasks.
        task['schedule_time'] = timestamp

        # Use the client to build and send the task.
        response = tasks.create_task(parent, task)

        print('Created task {}'.format(response.name))
        return response
        
    start = datetime.utcnow() 
    end = start + timedelta(hours = 1)
    docs = client.collection('Reminders').where('date', '>', start).where('date', '<', end).stream()
    for doc in docs:
        curr = doc.to_dict()
        uid = curr[u'uid']
        module = curr[u'moduleName']
        quiz = curr[u'quizName']
        quiz_ref = curr[u'quizDocRef']
        date = curr[u'date']
        client.collection('Reminders').document(doc.id).delete()
        make_task(uid, module, quiz, date, quiz_ref)
    task_docs = client.collection('TaskReminders').where('date', '>', start).where('date', '<', end).stream()
    for doc in task_docs:
        curr = doc.to_dict()
        uid = curr[u'uid']
        module = curr[u'moduleCode']
        quiz = curr[u'taskName']
        date = curr[u'date']
        client.collection('TaskReminders').document(doc.id).delete()
        make_task(uid, module, quiz, date)
    return 'OK'

def quiz_reminder(uid, module, quiz, quiz_ref=None):
    time.sleep(10)
    db = firestore.Client()
    doc_ref = db.collection(u'users').document(uid)
    curr = doc_ref.get().to_dict()
    curr = curr[u'token']
    if quiz_ref == None:
        message = messaging.Message(
                notification=messaging.Notification(
                    title='Remider to do task: {}'.format(quiz),
                    body='Here is a reminder to perform your task!',
                ),
                token=curr,
            )
    else:
        message = messaging.Message(
                data={
                    'quiz' : quiz_ref,
                },
                notification=messaging.Notification(
                    title='Remider to do quiz: {}'.format(quiz),
                    body='Time for you to refresh your memory with this quiz!',
                ),
                token=curr,
            )

        # Send a message to the device corresponding to the provided
        # registration token.
    response = messaging.send(message)
    
# quiz_reminder('hAlEXSdEqBg686exakfoXjUwLWE3', 'CS2030', 'midtorms', quiz_ref=None)
# quiz_reminder('EUA2XhAtRJMEjHqXYnpjG7HXCWn1', 'CS2030', 'Quiz1')

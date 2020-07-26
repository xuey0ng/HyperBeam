from datetime import datetime, timedelta
import json
from google.cloud import firestore, tasks_v2
from google.protobuf import timestamp_pb2

client = firestore.Client()
tasks = tasks_v2.CloudTasksClient()


def make_task_test(uid, module, quiz, quiz_ref, date):

   # Construct the fully qualified queue name.
    project = 'hyper-beam'
    queue = 'hyper-queue'
    location = 'asia-south1'
    parent = tasks.queue_path(project, location, queue)

    payload = uid + ',' + module + ',' + quiz + ',' + quiz_ref 

    # Construct the request body.
    # task = {
    #     'app_engine_http_request': {  # Specify the type of request.
    #         'http_method': 'POST',
    #         'relative_uri': '/task_handler'
    #     }
    # }

    # The API expects a payload of type bytes.
    converted_payload = payload.encode()

    # Add the payload to the request.
    # task['app_engine_http_request']['body'] = converted_payload

    # For testing 
    url = 'https://cec90c2a4c20.ngrok.io/task_handler'
    task = {
        'http_request': {  # Specify the type of request.
            'http_method': 'POST',
            'url': url,  # The full url path that the task will be sent to
            'body': converted_payload,
            
        }
    }

    # Create Timestamp protobuf.
    timestamp = timestamp_pb2.Timestamp()
    timestamp.FromDatetime(date)

    # Add the timestamp to the tasks.
    task['schedule_time'] = timestamp

    # Use the client to build and send the task.
    response = tasks.create_task(parent, task)

    print('Created task {}'.format(response.name))
    return response

# cloud scheduler to call get_updates once per hour
def get_updates_test(data, context):
    start = datetime.now()
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
        make_task_test(uid, module, quiz, quiz_ref, date)

# send to cloud tasks

def tester():
    # docs = client.collection('Reminders').limit(1).stream()
    start = datetime.utcnow()
    end = start + timedelta(hours = 1)
    docs = client.collection('Reminders').where('date', '>', start).where('date', '<', end).stream()
    # docs = client.collection('Reminders').stream()
    for doc in docs:
        curr = doc.to_dict()
        dt = curr['date']
        print(dt)

        # client.collection('Reminders').document(doc.id).delete()

def get_updates(data, context):
    start = datetime.now() - timedelta(hours = 8)
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
        client.collection('Reminders').document(doc.id).delete()
        make_task(uid, module, quiz, date)
    
def make_task(uid, module, quiz, date, quiz_ref=None):
    # Construct the fully qualified queue name.
    project = 'hyper-beam'
    queue = 'hyper-queue'
    location = 'asia-south1'
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



tester()
# uid = 'hAlEXSdEqBg686exakfoXjUwLWE3'
# module = 'CS2030'
# quiz = 'a'
# quiz_ref= 'Quizzes/5M6CjkTlcUyNJCset76m'
# date = datetime.utcnow()+timedelta(minutes=1)
# make_task(uid, module, quiz, date, quiz_ref)
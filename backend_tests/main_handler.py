from flask import Flask, request
import firebase_admin
from firebase_admin import messaging, credentials
from datetime import datetime
from google.cloud import firestore

app = Flask(__name__)


@app.route('/task_handler', methods=['POST'])
def task_handler():
    """Log the request payload."""
    payload = request.get_data(as_text=True) or '(empty payload)'
    print('Received task with payload: {}'.format(payload))
    date = datetime.now()
    payload = payload.split(',')
    uid = payload[0]
    module = payload[1]
    quiz = payload[2]
    quiz_ref = payload[3]
    quiz_reminder(uid,module,quiz,quiz_ref,date)
    return 'Printed task payload: {}'.format(payload), 200
# [END cloud_tasks_appengine_quickstart]






@app.route('/')
def hello():
    """Basic index to verify app is serving."""
    return 'Hello World!'


if __name__ == '__main__':
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine. See entrypoint in app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)


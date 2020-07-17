from flask import Flask, request
from google.cloud import messaging
import datetime

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

def quiz_reminder(uid, module, quiz, quiz_ref, date):
    doc_ref = self.db.collection(u'users').document(uid)
    curr = doc_ref.get().to_dict()
    curr = curr[u'token']
    token_dict[uid] = curr
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




@app.route('/')
def hello():
    """Basic index to verify app is serving."""
    return 'Hello World!'


if __name__ == '__main__':
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine. See entrypoint in app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
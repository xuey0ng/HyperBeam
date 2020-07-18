from pdf_highlights import PDFHighlights
import base64
import json
import logging
import os

from flask import current_app, Flask, render_template, request
from google.cloud import pubsub_v1


app = Flask(__name__)

# Configure the following environment variables via app.yaml
# This is used in the push request handler to verify that the request came from
# pubsub and originated from a trusted source.
app.config['PUBSUB_VERIFICATION_TOKEN'] = \
    os.environ['PUBSUB_VERIFICATION_TOKEN']
app.config['PUBSUB_TOPIC'] = os.environ['PUBSUB_TOPIC']
app.config['PROJECT'] = os.environ['GOOGLE_CLOUD_PROJECT']


# Global list to storage messages received by this instance.
MESSAGES = []

# Initialize the publisher client once to avoid memory leak
# and reduce publish latency.
publisher = pubsub_v1.PublisherClient()

# Set the logging for the GAE application


# [START gae_flex_pubsub_index]
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'GET':
        return render_template('index.html', messages=MESSAGES)

    data = request.form.get('payload', 'Example payload').encode('utf-8')

    # publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(
        current_app.config['PROJECT'],
        current_app.config['PUBSUB_TOPIC'])

    publisher.publish(topic_path, data=data)

    return 'OK', 200
# [END gae_flex_pubsub_index]


# [START gae_flex_pubsub_push]
@app.route('/pubsub/push', methods=['POST'])
def pubsub_push():
    if (request.args.get('token', '') !=
            current_app.config['PUBSUB_VERIFICATION_TOKEN']):
        return 'Invalid request', 400
    
    # Collect the metadata from the pubsub to determine message type
    logging.info('Document is created on cloud storage')
    envelope = json.loads(request.data.decode('utf-8'))
    payload = base64.b64decode(envelope['message']['data'])
    attributes = envelope['message']['attributes']
    event_type = str(attributes.get('eventType')) 
    bucket = attributes.get('bucketId')
    blob = attributes.get('objectId')
    generation_number = str(attributes.get('objectGeneration'))
    overwrote_generation = attributes.get('overwroteGeneration')
    overwritten_by_generation = attributes.get('overwrittenByGeneration')

    # To check if the upload is a new upload as well by checking if it overwrote something
    if event_type == 'OBJECT_FINALIZE':
        logging.info("{} : {}".format(bucket, blob))
        current = PDFHighlights.PDFhighlights()
        current.process(bucket, blob)
    MESSAGES.append(payload)
    
    # Returning any 2xx status indicates successful receipt of the message.
    return 'OK', 200
# [END gae_flex_pubsub_push]


@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500


# if __name__ == '__main__':
#     # This is used when running locally. Gunicorn is used to run the
#     # application on Google App Engine. See entrypoint in app.yaml.
#     app.run(host='127.0.0.1', port=8080, debug=True)
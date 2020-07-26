from datetime import datetime, timedelta
import json
import firebase_admin
from firebase_admin import credentials, firestore, messaging
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2
import time

PROJECT_ID = 'hyperbeam1-7ec13'

cred = credentials.ApplicationDefault()
default_app = firebase_admin.initialize_app(cred, {
  'projectId': PROJECT_ID,
})

client = firestore.Client()
tasks = tasks_v2.CloudTasksClient()

def send_to_topic(top, pdf_name, pdf_link):
        # See documentation on defining a message payload.
        # subscribtion_list = ['dCr9xMSFqvU:APA91bHPWbL1emvBG_J7cN2PSCIqIfutSY578CcPZs7GSboe95Ycgje5tkPutIONG3NWEuxTK1a-TzKzUkOFFQkyAtjpkNmWBrjoKUUzxlzabqGCXDNauHfcxlwVLNNbgPxw9vHqom-T']
        # messaging.subscribe_to_topic(subscribtion_list, top)
        try:
            message = messaging.Message(
                data={
                    'link' : pdf_link,
                },
                notification=messaging.Notification(
                    title='MasterPDF updated',
                    body='The PDF : {} you uploaded has been processed.'.format(pdf_name),
                ),
                topic=top,
            )
        except:
            print('error')
        # Send a message to the devices subscribed to the provided topic.
        response = messaging.send(message)
        # logging.info("Message is sent to all users suscribe to topic {}".format(topic))

send_to_topic('6c0ba98a464e7084bd2908ea8fc2df00','test2', 'google.com')
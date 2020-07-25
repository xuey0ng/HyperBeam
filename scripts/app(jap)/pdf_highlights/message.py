from __future__ import print_function
import firebase_admin
import os
import logging
from firebase_admin import credentials, messaging
from google.cloud import firestore, storage
import google.cloud.logging
import datetime
import time

# token_dict = dict()


class PushNoti:
    
    # Initialise the firestore and storage instance
    def __init__(self):
        self.db = firestore.Client()
        # log_client = google.cloud.logging.Client()
        # log_client.get_default_handler()
        # log_client.setup_logging()

    def send_to_user(self, uid, pdf_name, pdf_link = ''):
        # curr = token_dict.get(uid)
        # if curr is None:
        
        doc_ref = self.db.collection(u'users').document(uid)
        curr = doc_ref.get().to_dict()
        curr = curr[u'token']
        # token_dict[uid] = curr

        message = messaging.Message(
            data={
                'link' : pdf_link,
            },
            notification=messaging.Notification(
                title='MasterPDF updated',
                body='The PDF : {} you uploaded has been processed.'.format(pdf_name),
            ),
            token=curr,
        )

        # Send a message to the device corresponding to the provided
        # registration token.
        response = messaging.send(message)
        # Response is a message ID string.
        # logging.info("Message is sent to {} with a message id of {}".format(uid, response))
       

        # Create a button to suscribe users to a topic so that they can receive the latest updates from the master pdf whenever
        # there is a newer version of the master pdf
        # Topic can be suscribe to by both sides: idea 1 - when a user suscribes to a topic, the firebase is updated and I will use
        # messaging.subscribe_to_topic(tokens), where tokens is a non-empty list of tokens that wish to suscribe to a certain topic
        # benefit is that it allows me to check if a topic has any suscriptions before attempting to send the topic
        # Send to topic allows users to receive updates regarding a certain topic when a newer iteration is uploaded.
    def send_to_topic(self, top, pdf_name, pdf_link):
        # See documentation on defining a message payload.
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

        # Send a message to the devices subscribed to the provided topic.
        response = messaging.send(message)
        # logging.info("Message is sent to all users suscribe to topic {}".format(topic))
    
    def quiz_reminder(self, uid, module, quiz, quiz_ref=None):
        doc_ref = self.db.collection(u'users').document(uid)
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


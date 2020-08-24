import base64
import json
import os

import pytest

import main


@pytest.fixture
def client():
    main.app.testing = True
    return main.app.test_client()


def test_index(client):
    r = client.get('/')
    assert r.status_code == 200


def test_post_index(client):
    r = client.post('/', data={'payload': 'Test payload'})
    assert r.status_code == 200


def test_push_endpoint(client):
    url = '/pubsub/push?token=' + os.environ['PUBSUB_VERIFICATION_TOKEN']

    r = client.post(
        url,
        data=json.dumps({
            "message": {
                "data": base64.b64encode(
                    u'Test message'.encode('utf-8')
                ).decode('utf-8')
            }
        })
    )

    assert r.status_code == 200

    # Make sure the message is visible on the home page.
    r = client.get('/')
    assert r.status_code == 200
    assert 'Test message' in r.data.decode('utf-8')


def test_push_endpoint_errors(client):
    # no token
    r = client.post('/pubsub/push')
    assert r.status_code == 400

    # invalid token
    r = client.post('/pubsub/push?token=bad')
    assert r.status_code == 400
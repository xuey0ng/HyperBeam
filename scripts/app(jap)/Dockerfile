# From ubuntu 18.04 base image
FROM ubuntu:18.04

# instal python 3.7
RUN apt-get update && apt-get install \
    -y --no-install-recommends python3.7 python3-pip

# Removed the use of the virtual envirnment
# ENV VIRTUAL_ENV=/opt/venv
# RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy the requirements.txt from the current working directory
COPY requirements.txt .

# Install packages and dependencies
RUN apt-get install poppler-utils -y && \
    apt-get install -y python3-poppler-qt5 && \
    pip3 install --user --upgrade pip && \
    apt-get install -y gunicorn3 && \
    apt-get install -y python3-pyqt5 && \
    pip3 install -r requirements.txt

# Add the application source code.
COPY . /app
WORKDIR /app

# Set the environment variables
ENV PUBSUB_VERIFICATION_TOKEN=abc
ENV PUBSUB_TOPIC=projects/hyperbeam1-7ec13/topics/hyperbeam1-7ec13.appspot.com
ENV GOOGLE_CLOUD_PROJECT=hyperbeam1-7ec13
ENV GOOGLE_APPLICATION_CREDENTIALS="pdf_highlights/hyperbeam1-7ec13-firebase-adminsdk-6hitn-84f95b3bd1.json"

# Listen to port 8080
EXPOSE 8080

# Run a WSGI server to serve the application. gunicorn must be declared as
# a dependency in requirements.txt.
CMD gunicorn3 -b :$PORT main:app
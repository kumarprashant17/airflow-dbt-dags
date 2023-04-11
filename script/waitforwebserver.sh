#!/bin/bash
# https://unix.stackexchange.com/questions/5277/how-do-i-tell-a-script-to-wait-for-a-process-to-start-accepting-requests-on-a-po
echo "Waiting for webserver to be up ..."
while ! nc -q 1 localhost 8080 2>/dev/null; do sleep 5; done
echo "Airflow Webserver is up at http://localhost:8080"

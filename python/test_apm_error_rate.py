import time
import os
import urllib.request
from time import sleep
from datetime import datetime, timedelta
import json


def test_apm_error_rate():
  main_url = os.getenv("HOST_TEST_URL")
  for i in range(10):
    req = urllib.request.Request("{}/ecommerce".format(main_url))
    with urllib.request.urlopen(req) as response:
       body = response.read().decode("utf8")
    sleep(1)

  for i in range(10):
    req = urllib.request.Request("{}/healthcheck".format(main_url))
    with urllib.request.urlopen(req) as response:
       body = response.read().decode("utf8")
    sleep(1)

  now = datetime.now()
  five_minutes_ago = now - timedelta(minutes=5)
  params = {
    "start": five_minutes_ago.strftime("%Y-%m-%dT%H:%M:%SZ"),
    "end": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
    "kuery": "",
    "environment": "ENVIRONMENT_ALL",
    "serviceNames": "[\"jenkins\", \"frontend\"]",
    "offset": "1d"
  }
  host = os.getenv("KIBANA_URL")
  url = "{}/internal/apm/services/detailed_statistics?{}".format(host, urllib.parse.urlencode(params))
  req = urllib.request.Request(url)
  with urllib.request.urlopen(req) as response:
     body = response.read().decode("utf8")
     obj = json.loads(body)
     if obj["currentPeriod"]:
       if obj["currentPeriod"]["frontend"]:
         if obj["currentPeriod"]["frontend"]["transactionErrorRate"]:
           for item in obj["currentPeriod"]["frontend"]["transactionErrorRate"]:
             assert item.y == 0 or item.y == None

  pass

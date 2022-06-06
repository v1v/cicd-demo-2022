import time
import os
import urllib.request
from time import sleep
from datetime import datetime, timedelta
import json
import base64


def test_canary_health_check_with_elastic():
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
    "serviceNames": "[\"antifraud-01\"]",
    "offset": "1d"
  }
  host = os.getenv("KIBANA_URL")
  username = os.getenv("KIBANA_USR")
  password = os.getenv("KIBANA_PSW")
  url = "{}/internal/apm/services/detailed_statistics?{}".format(host, urllib.parse.urlencode(params))
  req = urllib.request.Request(url)
  base64string = base64.b64encode(bytes('%s:%s' % (username, password),'ascii'))
  req.add_header("Authorization", "Basic %s" % base64string.decode('utf-8'))
  with urllib.request.urlopen(req) as response:
     body = response.read().decode("utf8")
     obj = json.loads(body)
     if obj["currentPeriod"]:
       if obj["currentPeriod"]["antifraud-01"]:
         if obj["currentPeriod"]["antifraud-01"]["transactionErrorRate"]:
           for item in obj["currentPeriod"]["antifraud-01"]["transactionErrorRate"]:
             y = getattr(item, 'y', None)
             assert  y == 0 or y == None

  pass

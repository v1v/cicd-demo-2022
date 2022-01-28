import time
import os
import urllib.request
from random import randint
from time import sleep


def test_healthcheck():
    sleep(randint(1,2))
    url = os.getenv("SMOKE_TEST_URL")
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello World!") != -1
    pass

def test_healthcheck_with_request():
    sleep(randint(1,2))
    url = os.getenv("SMOKE_TEST_URL")
    req = urllib.request.Request("{}?name=foo".format(url))
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello foo!") != -1
    pass

# For adding slowness
def test_multiple_healthchecks():
    sleep(randint(1,4))
    url = os.getenv("SMOKE_TEST_URL")
    req = urllib.request.Request("{}?name=foo".format(url))
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello foo!") != -1
    pass

import time
import os
import urllib.request
from random import randint
from time import sleep


def test_default():
    sleep(randint(400,1000))
    url = os.getenv("SMOKE_TEST_URL")
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello World!") != -1
    pass

def test_name():
    sleep(randint(100,2000))
    url = os.getenv("SMOKE_TEST_URL")
    req = urllib.request.Request("{}?name=foo".format(url))
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello foo!") != -1
    pass

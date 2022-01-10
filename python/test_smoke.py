import time
import urllib.request

   
def test_default():
    req = urllib.request.Request('http://localhost:8080/hello')
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello World!") != -1
    pass

def test_name():
    req = urllib.request.Request('http://localhost:8080/hello?name=foo')
    with urllib.request.urlopen(req) as response:
       the_page = response.read().decode("utf8")
    assert the_page.find("Hello bar!") != -1
    pass

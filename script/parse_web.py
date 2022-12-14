import requests
from bs4 import BeautifulSoup
import json
import sys

def run (url):
    # Make a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content of the page
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find the elements on the page that contain the information you want to scrape
    rawJ = soup.find_all('script')

    J1 = str(rawJ[26]).split('var defaultSearch = ')
    J2 = J1[1].split('var onward_defaultSearch = ')[0]
    J3 = J2[1:-3]

    ourbus_object = json.loads(J3)

    with open("data/ourbus.json", "w") as f:
        json.dump(ourbus_object, f, indent=4)

if __name__ == "__main__":
    run(sys.argv[1])
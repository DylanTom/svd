import requests
from bs4 import BeautifulSoup
import json

# Set the URL for Ourbus
url = 'https://www.ourbus.com/booknow?origin=New%20York,%20NY&destination=Ithaca,%20NY&departure_date=12/08/2022&adult=1'

# Make a GET request to the URL
response = requests.get(url)

# Parse the HTML content of the page
soup = BeautifulSoup(response.text, 'html.parser')

# Find the elements on the page that contain the information you want to scrape
rawJ = soup.find_all('script')

J1 = str(rawJ[25]).split('var defaultSearch = ')
J2 = J1[1].split('var onward_defaultSearch = ')[0][1:-3]

ourbus_object = json.loads(J2)

with open("data/ourbus.json", "w") as f:
    json.dump(ourbus_object, f, indent=4)
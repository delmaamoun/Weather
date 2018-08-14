import json
from urllib.parse import urlencode
from urllib.request import urlopen
from flatten_json import flatten


def get_weather(city, country):
    baseurl = "https://query.yahooapis.com/v1/public/yql?"
    yql_query = "select item.condition.temp,units.temperature,location from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"" + city + "," + country + "\") AND u=\"C\""
    yql_url = baseurl + urlencode({'q': yql_query}) + "&format=json"
    result = urlopen(yql_url).read()
    data = json.loads(result)

    # remove nesting from output json
    flat = flatten(data, ".")

    return flat

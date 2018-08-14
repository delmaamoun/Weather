from flask import Flask, request, jsonify, abort, Response
from flask_restful import Api, Resource
from schema import Schema, And
from yahoo import get_weather

app = Flask(__name__)
app.config['JSONIFY_MIMETYPE'] = 'application/json'
api = Api(app)

requestSchema = Schema({'city': And(str, lambda s: 0 < len(s) <= 36), 'country': And(str, lambda s: 0 < len(s) <= 36)})


class Weather(Resource):
    def post(self):
        # Parse request & validate data
        validated = requestSchema.is_valid(request.json)
        if not validated:
            abort(422, "Invalid input fields")

        # retrieve info from yahoo weather
        result = get_weather(request.json['city'], request.json['country'])

        try:
            temperature = result['query.results.channel.item.condition.temp']
            unit = result['query.results.channel.units.temperature']
            cityname = result['query.results.channel.location.city']
            countryname = result['query.results.channel.location.country']

            if unit == "C":
                unit = "Celsius"
            elif unit == "F":
                unit = "Fahrenheit"

            # return results
            return jsonify(city=cityname, country=countryname, current=temperature, units=unit)
        except:
            return abort(400, "Yahoo Weather did not return valid data")


api.add_resource(Weather, '/')

if __name__ == '__main__':
    app.run(debug=True)

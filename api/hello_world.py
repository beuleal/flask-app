from datetime import datetime

from flask_restful import Resource, reqparse

from util import create_response, non_empty_string

parser = reqparse.RequestParser()


class HelloWorld(Resource):
    """
    Class to handler requests on "/"
    """

    def get(self):
        """
        Handler for HTTP GET request
        """

        json_data = {
            'output': f'Hello World!',
            'request_timestamp': datetime.now()
        }

        return create_response(json_data)

    def post(self):
        """
        Handler for HTTP POST request
        """

        # If name is not provided it will return HTTP code 400
        parser.add_argument('name',
                            required=True,
                            nullable=False,
                            type=non_empty_string,
                            help="Name cannot be blank!")

        args = parser.parse_args()
        name = args["name"]

        json_data = {
            'output': f'Hello, {name}!',
            'request_timestamp': datetime.now()
        }

        return create_response(json_data)

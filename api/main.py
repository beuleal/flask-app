from flask import Flask
from flask_restful import Api

from hello_world import HelloWorld

app = Flask(__name__)
api = Api(app)

# Availables Resources
api.add_resource(HelloWorld, '/')

# Main Configuration
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    app.run(debug=True)

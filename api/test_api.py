"""
Test class for Flusk API application.
"""

from main import app


def test_world():
    """
    This test will test if the output was "Hello World" for HTTP GET request
    """
    response = app.test_client().get('/')

    assert response.status_code == 200
    print(response.data)
    json_data = response.get_json()
    assert json_data["output"] == "Hello World!"


def test_name():
    """
    This test will test if the output was "Hello Brenno" for HTTP POST request with name parameter
    """

    response = app.test_client().post('/', json={
        "name": "Brenno"
    })

    assert response.status_code == 200

    json_data = response.get_json()
    assert json_data["output"] == "Hello, Brenno!"


def test_no_name():
    """
    This test will test if the response was an error as name was not sent
    """

    response = app.test_client().post('/')

    assert response.status_code == 400


def test_empty_name():
    """
    This test will test if the response was an error as name was empty
    """

    response = app.test_client().post('/', json={
        "name": ""
    })

    assert response.status_code == 400

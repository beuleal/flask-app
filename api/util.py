from flask import jsonify, make_response


def create_response(json_data):
    """
    Format the response
    """

    response = make_response(
        jsonify(
            json_data
        ),
        200,
    )
    response.headers["Content-Type"] = "application/json"
    return response

def non_empty_string(s):
    """
    It's a helper to prevent empty string in parameter requests
    """
    
    if not s:
        raise ValueError("Must not be empty string")
    return s

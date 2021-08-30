import json
import os


def lambda_handler(event, context):
    """
    Prints the current Environment Vars to the console and always returns "200 OK" and a greeting
    as json.
    :param event: The event dict that contains the parameters sent when the function
                  is invoked.
    :param context: The context in which the function is called. Provides methods and properties
                    that provide information about the invocation, function, and execution
                    environment
    :return: The result of the specified action.
    """
    print("Hello from CodingChallenge")
    print(os.environ)
    return {
        'statusCode': 200,
        'body':       json.dumps('Hello from CodingChallenge!')
    }

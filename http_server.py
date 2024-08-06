from flask import Flask, jsonify, request
import os
import argparse



app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the toy HTTP server!"

@app.route('/hello', methods=['GET'])
def hello():
    return jsonify(message="Hello, World!")



if __name__ == '__main__':
    # Set the HTTP server listening port from environment variable
    # Create the parser
    parser = argparse.ArgumentParser(description="HTTP based server")

    # Add arguments
    parser.add_argument(
        "--port", type=int, required=False, help="Port to run",default=5000
    )
    args = parser.parse_args()
    
    app.run(debug=True, port=args.port)

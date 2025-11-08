from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/api/test', methods=['GET'])
def test():
    return jsonify({"message": "Docker funciona!", "status": "ok"})

@app.route('/api/login', methods=['POST'])
def login_test():
    return jsonify({"message": "Login test OK", "status": "success"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False, port=5000)
import subprocess
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return "Hello Flask"

cmd = "[ -e run.sh ] && bash run.sh"
res = subprocess.call(cmd, shell=True)
if __name__ == '__main__':
    app.run(debug=True)  

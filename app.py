import os
import shutil
import subprocess
import http.server
import socketserver
import threading
import requests
from flask import Flask
import json
import time
import base64

app = Flask(__name__)

# Set environment variables
PROJECT_URL = os.environ.get('URL', '')
INTERVAL_SECONDS = int(os.environ.get("TIME", 120)) 
PORT = int(os.environ.get('SERVER_PORT') or os.environ.get('PORT') or 3000)

# http server
class MyHandler(http.server.SimpleHTTPRequestHandler):

    def log_message(self, format, *args):
        pass

    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Hello Flask')

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'Not found')

httpd = socketserver.TCPServer(('', PORT), MyHandler)
server_thread = threading.Thread(target=httpd.serve_forever)
server_thread.daemon = True
server_thread.start()

def filespsrun():
    command = f"[ -e run.sh ] && bash run.sh"
    try:
        subprocess.run(command, shell=True, check=True)
        print('Hello')
        subprocess.run('sleep 1', shell=True)
    except subprocess.CalledProcessError as e:
        print(f'error: {e}')

    subprocess.run('sleep 3', shell=True) 
	
filespsrun()


# auto visit project page
has_logged_empty_message = False

def visit_project_page():
    try:
        if not PROJECT_URL or not INTERVAL_SECONDS:
            global has_logged_empty_message
            if not has_logged_empty_message:
                print("Hello Flask")
                has_logged_empty_message = True
            return

        response = requests.get(PROJECT_URL)
        response.raise_for_status() 

        # print(f"Visiting project page: {PROJECT_URL}")
        print("Page visited successfully")
        print('\033c', end='')
    except requests.exceptions.RequestException as error:
        print(f"Error visiting project page: {error}")

if __name__ == "__main__":
    while True:
        visit_project_page()
        time.sleep(INTERVAL_SECONDS)

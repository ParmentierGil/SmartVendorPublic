# pylint: skip-file
from repositories.DataRepository import DataRepository
from helpers.TempSensor import TempSensor
from helpers.LCD import LCD
from helpers.Keypad import Keypad
from helpers.MuntstukAcceptor import MuntstukAcceptor
from helpers.LoadCell import LoadCell
from flask import Flask, jsonify
from flask_socketio import SocketIO
from flask_cors import CORS
from flask_script import Manager, Server
from RPi import GPIO

import time
import threading 
import multiprocessing as mp
import queue

message_queue = queue.Queue()

one_wire_file_name = "/sys/bus/w1/devices/28-60818f1d64ff/w1_slave"
one_wire_file = open(one_wire_file_name, 'r')

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

app = Flask(__name__)
app.config['SECRET_KEY'] = 'Hier mag je om het even wat schrijven, zolang het maar geheim blijft en een string is'

socketio = SocketIO(app, cors_allowed_origins="*")
CORS(app)

def print_messages_from_threads():
    message = message_queue.get()
    while True:
        print(message)
        message = message_queue.get()

t = threading.Thread(target=print_messages_from_threads)
t.start()

# API ENDPOINTS
@app.route('/')
def hallo():
    return 'niets'

@app.route('/flaske')
def hallo2():
    return "Server is running, er zijn momenteel geen API endpoints beschikbaar."    


# SOCKET IO
@socketio.on('connected')
def page_connected(msg):
    print(msg)
    socketio.emit('return_on_connect', 'Succesfully connected to backend')


lcd = LCD()
one_wire_temp_sensor = TempSensor(socketio, message_queue)
muntstuk_acceptor = MuntstukAcceptor(message_queue, lcd)
load_cell = LoadCell(lcd)
keypad = Keypad(message_queue, lcd, muntstuk_acceptor, load_cell)

lcd.setDaemon(True)
one_wire_temp_sensor.setDaemon(True)
muntstuk_acceptor.setDaemon(True)
keypad.setDaemon(True)

if __name__ == '__main__':
    try:
        lcd.start()
        one_wire_temp_sensor.start()
        keypad.start() 
        muntstuk_acceptor.start()
        print("Current Thread count: %i." % threading.active_count())
        socketio.run(app, debug=False, host='0.0.0.0', port=5500)
    except:
        GPIO.cleanup()


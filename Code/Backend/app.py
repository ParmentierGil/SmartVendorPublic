# pylint: skip-file
from repositories.DataRepository import DataRepository
from flask import Flask, jsonify
from flask_socketio import SocketIO
from flask_cors import CORS

from RPi import GPIO
from pad4pi import rpi_gpio

import time
import threading


GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

KEYPAD = [
        ["1","2","3","A"],
        ["4","5","6","B"],
        ["7","8","9","C"],
        ["*","0","#","D"]
]

ROW_PINS = [26, 19, 13, 6] 
COL_PINS = [5, 11, 9, 10]

factory = rpi_gpio.KeypadFactory()

# Try factory.create_4_by_3_keypad
# and factory.create_4_by_4_keypad for reasonable defaults
keypad = factory.create_keypad(keypad=KEYPAD, row_pins=ROW_PINS, col_pins=COL_PINS)


app = Flask(__name__)
app.config['SECRET_KEY'] = 'Hier mag je om het even wat schrijven, zolang het maar geheim blijft en een string is'

socketio = SocketIO(app, cors_allowed_origins="*")
CORS(app)


# API ENDPOINTS
@app.route('/')
def hallo():
    return "Server is running, er zijn momenteel geen API endpoints beschikbaar."


# SOCKET IO

#@socketio.on('F2B_switch_light')


def printKey(key):
  print(key)
  if (key=="1"):
    print("number")
  elif (key=="A"):
    print("letter")

# printKey will be called each time a keypad button is pressed
keypad.registerKeyPressHandler(printKey)

try:
    while(True):
        time.sleep(0.2)

except:
    keypad.cleanup()

finally:
    keypad.cleanup()



if __name__ == '__main__':
    socketio.run(app, debug=False, host='0.0.0.0')

import time
import threading
from repositories.DataRepository import DataRepository
from pad4pi import rpi_gpio

KEYPAD = [
        ["1","2","3","A"],
        ["4","5","6","B"],
        ["7","8","9","C"],
        ["*","0","#","D"]
        ]

ROW_PINS = [26, 19, 13, 6] 
COL_PINS = [5, 11, 9, 10]

factory = rpi_gpio.KeypadFactory()

class Keypad(threading.Thread):
    def __init__(self, message_queue):
        threading.Thread.__init__(self)
        self.message_queue = message_queue
        self.keypad = factory.create_keypad(keypad=KEYPAD, row_pins=ROW_PINS, col_pins=COL_PINS)
        self.input_string = ""

    def handle_key_press(self, key):
        if key == 'A':
            product_name = DataRepository.get_product_by_number(int(self.input_string))
            print(product_name)
            self.input_string = ""
        elif key in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']:
            self.input_string += key

    def run(self):
        try:
            self.keypad.registerKeyPressHandler(self.handle_key_press)
        except:
            self.keypad.cleanup()
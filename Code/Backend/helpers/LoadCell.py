from hx711 import HX711
import RPi.GPIO as GPIO
import threading
import time
from repositories.DataRepository import DataRepository

TARE_CONSTANT = 113900
GRAM_CONSTANT = 108

class LoadCell(threading.Thread):
    def __init__(self, lcd):
        threading.Thread.__init__(self)
        self.hx711 = HX711(
            dout_pin=27,
            pd_sck_pin=17,
            channel='A',
            gain=64
        )
        self.lcd = lcd

    def start_weighing(self):
        try:
            for i in range(0,20):
                self.hx711.reset()   # Before we start, reset the HX711 (not obligate)
                measures_avg = sum(self.hx711.get_raw_data()) / 5
                weight = round((measures_avg - TARE_CONSTANT) / GRAM_CONSTANT, 0)
                print(weight)
                DataRepository.insert_weight(weight)
                time.sleep(1)
        except Exception as e:
            print("Error with weighing"+ str(e))


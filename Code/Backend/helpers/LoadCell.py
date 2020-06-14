import sys
from hx711 import HX711
import RPi.GPIO as GPIO
import threading
import time
from repositories.DataRepository import DataRepository

TARE_CONSTANT = 0
GRAM_CONSTANT = 1


class LoadCell(threading.Thread):
    def __init__(self, lcd):
        threading.Thread.__init__(self)
        self.hx711 = HX711(27, 17, channel="A")
        self.lcd = lcd

    def item_dropped(self):
        try:
            self.hx711.reset()
            max_weight = 0
            for i in range(0, 3):
                measures_avg = sum(self.hx711.get_raw_data()) / 5
                weight = round(
                    max((measures_avg - TARE_CONSTANT) / GRAM_CONSTANT, 0), 0)
                print(weight)
                max_weight = max(weight, max_weight)
                DataRepository.insert_weight(weight)
                self.hx711.power_down()
                self.hx711.power_up()
            return max_weight > 10

        except Exception as e:
            print("Error with weighing" + str(e))


# l = LoadCell(5)
# l.item_dropped()
# GPIO.cleanup()

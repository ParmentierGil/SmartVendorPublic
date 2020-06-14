import RPi.GPIO as GPIO
import threading
import time

RELEASE_REVOLUTIONS = 2

class Motor(threading.Thread):
    def __init__(self, write_pin, read_pin):
        threading.Thread.__init__(self)
        self.motor_write_pin = write_pin
        self.motor_read_pin = read_pin
        self.gpio_setup()
        self.revolutions = 0

    def gpio_setup(self):   
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BCM)
        if self.motor_read_pin == 2:
            GPIO.setup(self.motor_read_pin, GPIO.IN)
        else:
            GPIO.setup(self.motor_read_pin, GPIO.IN, pull_up_down = GPIO.PUD_UP)
        GPIO.setup(self.motor_write_pin, GPIO.OUT)
        GPIO.output(self.motor_write_pin, 0)

    def release_item(self):
        GPIO.output(self.motor_write_pin, 1)
        item_released = 0
        last_status = 1

        while not item_released:
            status = GPIO.input(self.motor_read_pin)

            if status == 1 and last_status == 0:
                self.revolutions += 0.5

            if self.revolutions == RELEASE_REVOLUTIONS:
                GPIO.output(self.motor_write_pin, 0)   
                print("Item released!")
                self.revolutions = 0
                item_released = 1        
            
            last_status = status
            time.sleep(0.1)
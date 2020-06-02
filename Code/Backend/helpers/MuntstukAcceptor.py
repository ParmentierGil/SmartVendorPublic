import time
from threading import Lock, Thread 
from repositories.DataRepository import DataRepository
import RPi.GPIO as GPIO

current_milli_time = lambda: int(round(time.time() * 1000))

END_COIN_DELTA = 1000

PULSE_PIN = 3
COUNTER_PIN = 2

class MuntstukAcceptor(Thread):
    def __init__(self, message_queue, lcd):
        Thread.__init__(self)
        self.message_queue = message_queue
        self.money_paid = 0
        self.GPIO_setup()
        self.pulse_counter = 0  
        self.last_pulse_time = 0
        self.has_pulsed = False
        self.accepting_coins = True
        self.lcd = lcd

    def GPIO_setup(self):
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(PULSE_PIN, GPIO.IN)
        GPIO.setup(COUNTER_PIN, GPIO.IN)
    
    def incr_pulse(self, pin):   
        self.pulse_counter += 1
        print("Aantal pulses: " + str(self.pulse_counter))
        self.last_pulse_time = current_milli_time()
        self.has_pulsed = True

    def run(self):
        GPIO.add_event_detect(PULSE_PIN, GPIO.RISING,
                           self.incr_pulse)#, bouncetime=self.bouncetime)
        # vorige_status = 0
        # while True:
        #     signal = GPIO.input(PULSE_PIN)
        #     if vorige_status == 0 and signal == 1:
        #         self.pulse_counter += 1
        #         print("Aantal pulses: " + str(self.pulse_counter))
        #         self.last_pulse_time = current_milli_time()
        #         self.has_pulsed = True
        #         vorige_status = signal
        #     elif vorige_status == 1 and signal == 0:
        #         vorige_status = signal

        while self.accepting_coins:
            if self.has_pulsed:
                if current_milli_time() > self.last_pulse_time + END_COIN_DELTA:
                    if self.pulse_counter <= 5:
                        print("0.50 euro")
                        self.money_paid += 0.5
                        self.lcd.display_total_credit(self.money_paid)
                        DataRepository.insert_credit(0.5)   
                    elif self.pulse_counter <= 10:
                        print("1 euro")
                        self.money_paid += 1                   
                        self.lcd.display_total_credit(self.money_paid)
                        DataRepository.insert_credit(1)
                    elif self.pulse_counter <= 20:
                        print("2 euro")
                        self.money_paid += 2
                        self.lcd.display_total_credit(self.money_paid)
                        DataRepository.insert_credit(2)        
                    else:
                        print("wrong coin")
                    self.pulse_counter = 0
                    self.has_pulsed = False



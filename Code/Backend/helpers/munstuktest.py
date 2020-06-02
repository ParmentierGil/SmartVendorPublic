import time
import threading
import RPi.GPIO as GPIO

current_milli_time = lambda: int(round(time.time() * 1000))

END_COIN_DELTA = 1000

PULSE_PIN = 3
COUNTER_PIN = 2

class MuntstukAcceptor():
    def __init__(self):
        self.GPIO_setup()
        self.pulse_counter = 0  
        self.last_pulse_time = 0
        self.has_pulsed = False 
        self.start()

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

    def start(self):
        GPIO.add_event_detect(PULSE_PIN, GPIO.RISING,
                            self.incr_pulse)#, bouncetime=self.bouncetime)
        while True:
            if self.has_pulsed:
                if current_milli_time() > self.last_pulse_time + END_COIN_DELTA:
                    if self.pulse_counter <= 5:
                        print("0.50 euro")
                    elif self.pulse_counter <= 10:
                        print("1 euro")
                    elif self.pulse_counter <= 20:
                        print("2 euro")
                    else:
                        print("wrong coin")
                    self.pulse_counter = 0
                    self.has_pulsed = False
        # vorige_status = 0
        # while True:
        #     status = GPIO.input(PULSE_PIN)
        #     print(status)
        #     if self.has_pulsed:
        #         if current_milli_time() > self.last_pulse_time + END_COIN_DELTA:
        #             if self.pulse_counter <= 5:
        #                 print("0.50 euro")
        #             elif self.pulse_counter <= 10:
        #                 print("1 euro")
        #             elif self.pulse_counter <= 20:
        #                 print("2 euro")
        #             else:
        #                 print("wrong coin")
        #             self.pulse_counter = 0
        #             self.has_pulsed = False
        #     if vorige_status == 1 and status == 0:
        #         self.pulse_counter += 1
        #         print("Aantal pulses: " + str(self.pulse_counter))
        #         self.last_pulse_time = current_milli_time()
        #         self.has_pulsed = True
        #         vorige_status = 0
        #     elif vorige_status == 0 and status == 1:
        #         vorige_status == 1
            
            


coin = MuntstukAcceptor()



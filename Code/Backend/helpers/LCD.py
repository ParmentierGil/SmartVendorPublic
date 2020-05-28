import RPi.GPIO as GPIO
import time
import threading


datapins = [24, 25, 7, 8]
RS = 18
E = 23

class LCD(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def __init_GPIO(self):
        GPIO.setmode(GPIO.BCM)
        for pin in datapins:
            GPIO.setup(pin, GPIO.OUT)
        GPIO.setup(RS, GPIO.OUT)
        GPIO.setup(E, GPIO.OUT)
        

    def __set_data_bits(self, byte):
        mask = 1

        for i in range(4, 8):
            bit = (mask << i & byte) >> i
            print("bit " + str(i) + ": " + str(bit) + " to pin: "+ str(datapins[i-4]))
            GPIO.output(datapins[i-4], bit)

        for i in range(0, 4):
            bit = (mask << i & byte) >> i
            print("bit " + str(i) + ": " + str(bit) + " to pin: "+ str(datapins[i-4]))
            GPIO.output(datapins[i], bit)

    def __send_instruction(self, byte, full=False):
        mask = 1
        for i in range(4, 8):
            bit = (mask << i & byte) >> i
            print("bit " + str(i) + ": " + str(bit) + " to pin: "+ str(datapins[i-4]))
            GPIO.output(datapins[i-4], bit)

        if full:
            for i in range(0, 4):
                bit = (mask << i & byte) >> i
            print("bit " + str(i) + ": " + str(bit) + " to pin: "+ str(datapins[i]))
            GPIO.output(datapins[i], bit)

        GPIO.output(RS, 0)
        GPIO.output(E, 1)
        GPIO.output(E, 0)
        time.sleep(0.02)


    def __send_character(self, byte):
        self.__set_data_bits(byte)
        GPIO.output(RS, 1)
        GPIO.output(E, 1)
        GPIO.output(E, 0)
        time.sleep(0.02)


    def init_lcd(self):
        self.__init_GPIO()
        self.__send_instruction(0b00110000)
        self.__send_instruction(0b00110000)
        self.__send_instruction(0b00110000)
        self.__send_instruction(0b00100000)
        self.__send_instruction(0b00101000, True) #function set
        self.__send_instruction(0b00001000, True) #display off
        self.__send_instruction(0b00000001, True) #clear screen
        self.__send_instruction(0b00001110, True) #display on


    def run(self):
        self.E = E
        self.RS = RS
        self.datapins = datapins
        self.init_lcd()


    def write_message(self, message):
        for letter in message:
            char = int(bin(ord(letter)), 2)
            print(char)
            self.__send_character(char)

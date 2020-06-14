import RPi.GPIO as GPIO
import time
import threading
import socket
import netifaces as ni
from repositories.DataRepository import DataRepository

# Define GPIO to LCD mapping
LCD_RS = 18
LCD_E = 23
LCD_D4 = 7
LCD_D5 = 8
LCD_D6 = 25
LCD_D7 = 24

# Define some device constants
LCD_WIDTH = 16    # Maximum characters per line
LCD_CHR = True
LCD_CMD = False

LCD_LINE_1 = 0x80  # LCD RAM address for the 1st line
LCD_LINE_2 = 0xC0  # LCD RAM address for the 2nd line

# Timing constants
E_PULSE = 0.0005
E_DELAY = 0.0005


class LCD(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.__init_lcd()
        print("hier")

    def __init_GPIO(self):
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BCM)       # Use BCM GPIO numbers
        GPIO.setup(LCD_E, GPIO.OUT)  # E
        GPIO.setup(LCD_RS, GPIO.OUT)  # RS
        GPIO.setup(LCD_D4, GPIO.OUT)  # DB4
        GPIO.setup(LCD_D5, GPIO.OUT)  # DB5
        GPIO.setup(LCD_D6, GPIO.OUT)  # DB6
        GPIO.setup(LCD_D7, GPIO.OUT)  # DB7

    def __lcd_byte(self, bits, mode):
        # Send byte to data pins
        # bits = data
        # mode = True  for character
        #        False for command

        GPIO.output(LCD_RS, mode)  # RS

        # High bits
        GPIO.output(LCD_D4, False)
        GPIO.output(LCD_D5, False)
        GPIO.output(LCD_D6, False)
        GPIO.output(LCD_D7, False)
        if bits & 0x10 == 0x10:
            GPIO.output(LCD_D4, True)
        if bits & 0x20 == 0x20:
            GPIO.output(LCD_D5, True)
        if bits & 0x40 == 0x40:
            GPIO.output(LCD_D6, True)
        if bits & 0x80 == 0x80:
            GPIO.output(LCD_D7, True)

        # Toggle 'Enable' pin
        self.__lcd_toggle_enable()

        # Low bits
        GPIO.output(LCD_D4, False)
        GPIO.output(LCD_D5, False)
        GPIO.output(LCD_D6, False)
        GPIO.output(LCD_D7, False)
        if bits & 0x01 == 0x01:
            GPIO.output(LCD_D4, True)
        if bits & 0x02 == 0x02:
            GPIO.output(LCD_D5, True)
        if bits & 0x04 == 0x04:
            GPIO.output(LCD_D6, True)
        if bits & 0x08 == 0x08:
            GPIO.output(LCD_D7, True)

        # Toggle 'Enable' pin
        self.__lcd_toggle_enable()

    def __lcd_toggle_enable(self):
        # Toggle enable
        time.sleep(E_DELAY)
        GPIO.output(LCD_E, True)
        time.sleep(E_PULSE)
        GPIO.output(LCD_E, False)
        time.sleep(E_DELAY)

    def __init_lcd(self):
        self.__init_GPIO()
        self.__lcd_byte(0x33, LCD_CMD)  # 110011 Initialise
        self.__lcd_byte(0x32, LCD_CMD)  # 110010 Initialise
        self.__lcd_byte(0x06, LCD_CMD)  # 000110 Cursor move direction
        # 001100 Display On,Cursor Off, Blink Off
        self.__lcd_byte(0x0C, LCD_CMD)
        # 101000 Data length, number of lines, font size
        self.__lcd_byte(0x28, LCD_CMD)
        self.__lcd_byte(0x01, LCD_CMD)  # 000001 Clear display
        time.sleep(E_DELAY)
        self.__create_euro_char()

    def __create_euro_char(self):
        self.__lcd_byte(64, LCD_CMD)
        self.__lcd_byte(7, LCD_CHR)
        self.__lcd_byte(8, LCD_CHR)
        self.__lcd_byte(30, LCD_CHR)
        self.__lcd_byte(8, LCD_CHR)
        self.__lcd_byte(30, LCD_CHR)
        self.__lcd_byte(8, LCD_CHR)
        self.__lcd_byte(7, LCD_CHR)
        self.__lcd_byte(0, LCD_CHR)
        self.__lcd_byte(LCD_LINE_1, LCD_CMD)

    def run(self):
        self.write_message("Smart Vendor", LCD_LINE_1)
        self.write_message("Credit:    €0.00", LCD_LINE_2)

    def write_message(self, message, line, clear=False):
        if clear:
            self.__lcd_byte(0x01, LCD_CMD)  # 000001 Clear display

        message = message.ljust(LCD_WIDTH, " ")

        self.__lcd_byte(line, LCD_CMD)

        for i in range(LCD_WIDTH):
            if message[i] == '€':
                self.__lcd_byte(0, LCD_CHR)
            else:
                self.__lcd_byte(ord(message[i]), LCD_CHR)

    def display_total_credit(self, total_credit):
        self.write_message("Smart Vendor", LCD_LINE_1)
        self.write_message(
            "Credit:    €" + '{0:.2f}'.format(total_credit), LCD_LINE_2)

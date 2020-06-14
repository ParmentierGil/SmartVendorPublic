import time
import threading
from repositories.DataRepository import DataRepository
from pad4pi import rpi_gpio
import netifaces as ni
import random

LCD_LINE_1 = 0x80
LCD_LINE_2 = 0xC0

KEYPAD = [
    ["1", "2", "3", "A"],
    ["4", "5", "6", "B"],
    ["7", "8", "9", "C"],
    ["*", "0", "#", "D"]
]

COL_PINS = [6, 13, 19, 26]
# COL_PINS = [5, 11, 9, 10]
ROW_PINS = [10, 9, 11, 5]

factory = rpi_gpio.KeypadFactory()


class Keypad(threading.Thread):
    def __init__(self, message_queue, lcd, muntstuk_acceptor, load_cell, motors):
        threading.Thread.__init__(self)
        self.message_queue = message_queue
        self.keypad = factory.create_keypad(
            keypad=KEYPAD, row_pins=ROW_PINS, col_pins=COL_PINS)
        self.input_string = ""
        self.lcd = lcd
        self.muntstuk_acceptor = muntstuk_acceptor
        self.load_cell = load_cell
        self.motors = motors
        self.ip_shown = False

    def handle_key_press(self, key):
        if key == 'A' and len(self.input_string) > 0:
            product = DataRepository.get_product_by_number(
                int(self.input_string))
            self.input_string = ""

            if product == None:
                print('Geen product met dit nummer.')
                self.lcd.write_message("Fout nummer", LCD_LINE_2)
            elif product['Price'] > self.muntstuk_acceptor.money_paid:
                self.lcd.write_message("Niet genoeg credit", LCD_LINE_2)
            else:
                self.lcd.write_message(product['Name'], LCD_LINE_2)
                self.muntstuk_acceptor.money_paid -= float(product['Price'])

                choices = ["top_left", "top_right",
                           "bottom_left", "bottom_right"]
                choice = choices[product["NumberInVendingMachine"]-1]

                self.motors[choice].release_item()

                # while not self.load_cell.item_dropped():
                #     self.motors[choice].release_item()
                print("Item dropped!")

                self.muntstuk_acceptor.accepting_coins = True

        elif key == 'C' and len(self.input_string) > 0:
            self.input_string = self.input_string[0:len(self.input_string)-1]
            self.lcd.write_message(self.input_string, LCD_LINE_2)

        elif key in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']:
            self.input_string += key
            print(self.input_string)
            if len(self.input_string) == 1:
                self.muntstuk_acceptor.accepting_coins = False
                self.lcd.write_message("Keuze Product:", LCD_LINE_1, True)
            self.lcd.write_message(self.input_string, LCD_LINE_2)

        elif key == 'D':
            if not self.ip_shown:
                self.muntstuk_acceptor.accepting_coins = False
                ni.ifaddresses('wlan0')
                ip = ni.ifaddresses('wlan0')[ni.AF_INET][0]['addr']
                self.lcd.write_message(ip, LCD_LINE_1, True)
                self.ip_shown = True
            else:
                if len(self.input_string) > 0:
                    self.muntstuk_acceptor.accepting_coins = False
                    self.lcd.write_message(
                        "Keuze Product:", LCD_LINE_1, clear=True)
                    self.lcd.write_message(self.input_string, LCD_LINE_2)
                    self.ip_shown = False
                else:
                    self.muntstuk_acceptor.accepting_coins = True
                    self.lcd.display_total_credit(
                        self.muntstuk_acceptor.money_paid)
                    self.ip_shown = False

    def run(self):
        try:
            self.keypad.registerKeyPressHandler(self.handle_key_press)
        except:
            self.keypad.cleanup()

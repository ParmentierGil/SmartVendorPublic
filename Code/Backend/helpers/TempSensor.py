import time
current_milli_time = lambda: int(round(time.time() * 1000))
from threading import Thread, Lock
from repositories.DataRepository import DataRepository

one_wire_file_name = "/sys/bus/w1/devices/28-60818f1d64ff/w1_slave"
one_wire_file = open(one_wire_file_name, 'r')

class TempSensor(Thread):
    def __init__(self, socket, message_queue):
        Thread.__init__(self)
        self.socket = socket
        self.message_queue = message_queue
        self.last_temp_reading_time = 0
        self.temp_reading_delta = 30000

    def run(self):
        try:
            while True:
                if current_milli_time() > (self.last_temp_reading_time + self.temp_reading_delta):
                    self.read_temperature()
                    self.last_temp_reading_time = current_milli_time()
        except:
            one_wire_file.close()

        finally:
            one_wire_file.close()

    def read_temperature(self):
        for line in one_wire_file:
            if 't=' in line:
                temp_index = line.index('t=') + 2
                temp = line[temp_index:]
                self.message_queue.put(temp)
                DataRepository.update_temperature(temp)
                self.socket.emit("new_temp", temp)
        one_wire_file.seek(0)
    

import RPi.GPIO as GPIO
import time

# Chân GPIO được sử dụng để điều khiển IC CD4511
A = 11
B = 12
C = 13
D = 15

# Cấu hình chế độ chân GPIO
GPIO.setmode(GPIO.BOARD)
GPIO.setup(A, GPIO.OUT)
GPIO.setup(B, GPIO.OUT)
GPIO.setup(C, GPIO.OUT)
GPIO.setup(D, GPIO.OUT)

# Hàm để hiển thị số từ 0 đến 9
def display_number(number):
    GPIO.output(A, number & 1)
    GPIO.output(B, (number >> 1) & 1)
    GPIO.output(C, (number >> 2) & 1)
    GPIO.output(D, (number >> 3) & 1)

# Chạy vòng lặp để hiển thị các số từ 0 đến 9 liên tiếp
try:
    while True:
        for number in range(10):
            display_number(number)
            time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()
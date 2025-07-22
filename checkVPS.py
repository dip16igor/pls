import time
from ping3 import ping
from datetime import datetime

# Укажите IP-адрес или доменное имя вашего VPS
VPS_ADDRESS = '36.8.233.146'
# Файл для записи логов
LOG_FILE = 'connection_log.txt'


def log_status(status):
    with open(LOG_FILE, 'a') as f:
        f.write(f"{datetime.now()}: {status}\n")


def check_connection():
    response = ping(VPS_ADDRESS)
    return response is not None


def main():
    log_status("Start monitoring")
    was_connected = True

    while True:
        is_connected = check_connection()

        if was_connected is None:
            was_connected = is_connected

        if is_connected and not was_connected:
            log_status("Connection lost")
        elif not is_connected and was_connected:
            log_status("Connection restored")

        was_connected = is_connected
        time.sleep(30)  # Ждем 5 минут


if __name__ == "__main__":
    main()

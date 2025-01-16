from datetime import datetime
import socket

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('localhost', 12345))
client_socket.send("monitor".encode())

while True:
    data = client_socket.recv(1024).decode()
    print(f'{datetime.now().strftime("%H:%M:%S.%f")} : {data}')
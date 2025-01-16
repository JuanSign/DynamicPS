import datetime
import json
import socket

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('localhost', 12345))
client_socket.send("controller".encode())

while True:
    vessel_directions = float(input('vessel dir: '))
    thruster_power = list(map(float, input('tp: ').split()))
    thruster_fault = list(map(float, input('tf: ').split()))

    data = json.dumps({
        'ves_dir' : vessel_directions,
        'thr_pow' : thruster_power,
        'thr_flt' : thruster_fault
    })
    client_socket.send(data.encode())
    print(f'{datetime.now().strftime("%H:%M:%S.%f")} : DATA SENT')

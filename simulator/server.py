from datetime import datetime
import asyncio
import json
import socket
import threading

from state import State

def LOG(message):
    print(f'{datetime.now().strftime("%H:%M:%S.%f")} : {message}')

async def _HANDLE_CONTROLLER(client_socket, client_address, STATE):
    LOG(f'HANDLING CONTROLLER {client_address}')
    while True:
        try:
            message = client_socket.recv(1024).decode()
            if not message:
                print(f"CLIENT {client_address} DISCONNECTED.")
                break
            
            data = json.loads(message)
            await STATE.SET_DATA(data['ves_dir'], data['thr_pow'], data['thr_flt'])
            LOG(f"{client_address} -> STATE UPDATED BY CONTROLLER")
            
        except ConnectionResetError:
            LOG(f"CLIENT {client_address} FORCEFULLY CLOSED THE CONNECTION.")
            break
        except Exception as e:
            LOG(f"ERROR : {e}")
            break

    client_socket.close()

def HANDLE_CONTROLLER(client_socket, client_address, STATE):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(_HANDLE_CONTROLLER(client_socket, client_address, STATE))

async def _HANDLE_MONITOR(client_socket, client_address, STATE):
    LOG(f'HANDLING MONITOR {client_address}')
    while True:
        data = await STATE.GET_DATA()
        client_socket.send(data.encode())
        LOG(f"{client_address} <- UPDATED STATE SENT")
        await asyncio.sleep(2)

def HANDLE_MONITOR(client_socket, client_address, STATE):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(_HANDLE_MONITOR(client_socket, client_address, STATE))

async def _UPDATE_STATE(STATE):
    LOG('SIMULATOR STARTED')
    while True:
        await asyncio.sleep(2)
        await STATE.UPDATE()
        LOG("SYSTEM -> STATE UPDATED BY SYSTEM")

def UPDATE_STATE(STATE):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(_UPDATE_STATE(STATE))

async def _START_SERVER():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # addr = input("IP ADDRESS : ")
    # port = int(input("PORT : "))
    server_socket.bind(('0.0.0.0', 12345))
    server_socket.listen(5) 

    LOG(f"SERVER DEPLOYED ON {'0.0.0.0'}:{12345}.")

    STATE = State()
    await STATE.INITIALIZE(4)
    LOG("STATE CREATED")

    simulator = threading.Thread(target=UPDATE_STATE, args=(STATE,))
    simulator.daemon = True
    simulator.start()

    while True:
        try:
            client_socket, client_address = server_socket.accept()
            LOG(f"INCOMING CONNECTION: {client_address}")
            
            type = client_socket.recv(1024).decode()
            if type == 'controller':
                client_thread = threading.Thread(target=HANDLE_CONTROLLER, args=(client_socket, client_address, STATE))
            if type == 'monitor':
                client_thread = threading.Thread(target=HANDLE_MONITOR, args=(client_socket, client_address, STATE))

            client_thread.daemon = True 
            client_thread.start()
        except Exception as e:
            LOG(f"MAIN LOOP ERROR -> {e}")

def START_SERVER():
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(_START_SERVER())

if __name__ == "__main__":
    START_SERVER()

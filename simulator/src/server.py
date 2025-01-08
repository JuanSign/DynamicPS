import asyncio
import websockets

from generator import Generator

generator = Generator(50,250,4,4)

clients = set()
async def send_data_to_clients():
    while True:
        data = generator.GetData()
        if clients: 
            for client in clients:
                try:
                    await client.send(data)
                except:
                    print("Error sending data to a client")
        await asyncio.sleep(1)

async def handle_client(websocket):
    clients.add(websocket)
    print(f"New client connected: {websocket.remote_address}")

    try:
        await websocket.wait_closed()
    finally:
        clients.remove(websocket)
        print(f"Client disconnected: {websocket.remote_address}")

async def main():
    server = await websockets.serve(handle_client, "192.168.2.62", 8765)
    
    asyncio.create_task(send_data_to_clients())
    await server.wait_closed()

asyncio.run(main())

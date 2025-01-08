import asyncio
import websockets

async def listen_to_websocket():
    uri = "ws://192.168.2.62:8765"  
    try:
        async with websockets.connect(uri) as websocket:
            print("Connected to the server")
            
            while True:
                try:
                    message = await websocket.recv()  
                    print(f"Received message: {message}")
                except websockets.exceptions.ConnectionClosed:
                    print("Connection closed")
                    break
                except Exception as e:
                    print(f"Error: {e}")
                    break
    except Exception as e:
        print(f"Failed to connect: {e}")


asyncio.run(listen_to_websocket())

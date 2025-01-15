# for testing purposes...

import asyncio
import json
import math
import random
import websockets

async def listen(server):
    while True:
        data = await server.recv()
        print(data)

async def main():
    async with websockets.connect('ws://localhost:8765') as server:
        await server.send(json.dumps({
            'Vessel_Direction' : random.uniform(0, 2*math.pi),
            'Thruster_Power' : [30 for i in range(4)]
        }))
        asyncio.create_task(listen(server))
        await asyncio.Future()

asyncio.run(main())
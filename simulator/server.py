from datetime import datetime
import asyncio
import json
import websockets

from state import State

CLIENTS = set()

def unpack(data):
    parsed = json.loads(data)
    Vessel_Direction = parsed['Vessel_Direction']
    Thruster_Power = parsed['Thruster_Power']
    if 'Thruster_Fault' in parsed:
        Thruster_Fault = parsed['Thruster_Fault']
    else: Thruster_Fault = None
    return Vessel_Direction, Thruster_Power, Thruster_Fault

async def handler(client):
    CLIENTS.add(client)
    try:
        state = State()
        initial_state = await client.recv()
        Vessel_Direction, Thruster_Power, _ = unpack(initial_state)
        
        await state.INITIALIZE(Vessel_Direction, Thruster_Power)

        asyncio.create_task(broadcast(client, state))

        while True:
            data = await client.recv()
            Vessel_Direction, Thruster_Power, Thruster_Fault = unpack(data)
            await state.SET_DATA(Vessel_Direction, Thruster_Power, Thruster_Fault)
            print(f"UPDATE BASED ON CLIENT : {datetime.now().strftime('%H:%M:%S')}")
    except Exception as e:
        print(f"ERROR: {e}")

async def broadcast(client, state):
    while True:
        await asyncio.sleep(2)
        await state.UPDATE()
        data = await state.GET_DATA()
        await client.send(data)
        print(f"SENT {datetime.now().strftime('%H:%M:%S')}")

async def main():
    server = await websockets.serve(handler, '0.0.0.0', 8765)
    await server.wait_closed()

asyncio.run(main())
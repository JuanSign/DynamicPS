import asyncio
import json
import math
import random

class State:
    async def INITIALIZE(self, n):
        self.LOCK = asyncio.Lock()
        self.Vessel_Direction = random.uniform(0, 2*math.pi)
        self.Thruster_Power = [random.uniform(0,100) for i in range(n)]
        self.Thruster_Fault = [0 for i in range(n)]

        self.Wave_Direction = random.uniform(0, 2*math.pi)
        self.Curr_Direction = random.uniform(0, 2*math.pi)
        self.Wind_Direction = random.uniform(0, 2*math.pi)

        self.Wave_Change = 0
        self.Curr_Change = 0
        self.Wind_Change = 0

        self.Wave_New = 0
        self.Curr_New = 0
        self.Wind_New = 0

        self.Weather = random.uniform(0,1)
        self.Weather_Time = 0

        await self.UPDATE()

    async def SET_DATA(self, Vessel_Direction, Thruster_Power, Thruster_Fault):
        async with self.LOCK:
            self.Vessel_Direction = Vessel_Direction
            self.Thruster_Power = Thruster_Power
            self.Thruster_Fault = Thruster_Fault

    async def UPDATE(self):
        async with self.LOCK:
            if not self.Wave_Change:
                if random.uniform(0,1) < 0.2:
                    self.Wave_Change = random.randint(5,10)
                    self.Wave_New = random.uniform(0, 2*math.pi)
            if not self.Curr_Change:
                if random.uniform(0,1) < 0.2:
                    self.Curr_Change = random.randint(5,10)
                    self.Wave_New = random.uniform(0, 2*math.pi)
            if not self.Wind_Change:
                if random.uniform(0,1) < 0.2:
                    self.Wind_Change = random.randint(5,10)
                    self.Wind_New = random.uniform(0, 2*math.pi)
            
            if self.Wave_Change:
                self.Wave_Direction += (self.Wave_New-self.Wave_Direction)/self.Wave_Change
                self.Wave_Change -= 1
            else:
                mult = random.choice([1,-1])
                self.Wave_Direction += mult*random.uniform(0,0.5)

            if self.Curr_Change:
                self.Curr_Direction += (self.Curr_New-self.Curr_Direction)/self.Curr_Change
                self.Curr_Change -=1 
            else:
                mult = random.choice([1,-1])
                self.Curr_Direction += mult*random.uniform(0,0.5)
            
            if self.Wind_Change:
                self.Wind_Direction += (self.Wind_New-self.Wind_Direction)/self.Wind_Change
                self.Wind_Change -= 1
            else:
                mult = random.choice([1,-1])
                self.Wind_Direction += mult*random.uniform(0,0.5)

            if not self.Weather_Time:
                self.Weather_Time = random.randint(5,10)

            for i in range(len(self.Thruster_Fault)):
                if self.Thruster_Fault[i] : continue
                
                if self.Thruster_Power[i] < 50: fault_prob = 0.1
                elif self.Thruster_Power[i] < 75: fault_prob = 0.15
                elif self.Thruster_Power[i] < 90: fault_prob = 0.25
                else: fault_prob = 0.4

                if random.uniform(0,1) < fault_prob:
                    self.Thruster_Fault[i] = 1

            if self.Weather < 0.4:
                self.Wind_Strength = random.uniform(5,15)
                self.Wave_Height = random.uniform(0.5, 1.5)
                self.Curr_Strength = random.uniform(0.5,1)
            elif self.Weather < 0.7:
                self.Wind_Strength = random.uniform(15,25)
                self.Wave_Height = random.uniform(2, 4)
                self.Curr_Strength = random.uniform(1,2)
            elif self.Weather < 0.9:
                self.Wind_Strength = random.uniform(25,40)
                self.Wave_Height = random.uniform(4, 7)
                self.Curr_Strength = random.uniform(2,3)
            else:
                self.Wind_Strength = random.uniform(40,60)
                self.Wave_Height = random.uniform(7, 15)
                self.Curr_Strength = random.uniform(3,4)                                

            self.Weather_Time -= 1
        
    async def GET_DATA(self):
        async with self.LOCK:
            return json.dumps({
                'wave_dir' : (self.Wave_Direction + math.pi/2 - self.Vessel_Direction)%(math.pi*2),
                'curr_dir' : (self.Curr_Direction + math.pi/2 - self.Vessel_Direction)%(math.pi*2),
                'wind_dir' : (self.Wind_Direction + math.pi/2 - self.Vessel_Direction)%(math.pi*2),
                'wave_hgt' : (self.Wave_Height),
                'curr_str' : (self.Curr_Strength),
                'wind_str' : (self.Wind_Strength),
                'thruster_fault' : (self.Thruster_Fault)
            })
    
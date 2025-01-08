import random
import math
import json

class Generator:

    def __init__(self, vessel_width, vessel_height, n_wind_sensor, n_wave_sensor):
        self.vessel_width  = vessel_width
        self.vessel_height = vessel_height
        self.n_wind_sensor = n_wind_sensor
        self.n_wave_sensor = n_wave_sensor

        self.wave_direction = math.radians(random.uniform(0,360))
        self.wind_direction = self.wave_direction;

        self.wave_speed = random.uniform(1,4)
        self.wind_speed = random.uniform(5,15)

        self.abnormal = False
        self.abnormal_time = -1;
        self.wave_delta_multiplier = 1
        self.wind_delta_multiplier = 1

        self.state = "normal"

        self.iteration = 0

    def _GetDirectionDelta(self):
        if self.iteration % 5 == 0:
            if random.uniform(0,1) > 0.5:
                self.wave_delta_multiplier *= -1
            if random.uniform(0,1) > 0.5:
                self.wind_delta_multiplier *= -1

        return math.pi/6 * math.sin(0.02 * self.iteration)

    def _GetPoints(self, cx, cy, side_length, theta, n):
        half_side = side_length / 2
        points = []
        
        for _ in range(n):
            local_x = random.uniform(-half_side, half_side)
            local_y = random.uniform(-half_side, half_side)
            
            rotated_x = (local_x * math.cos(theta)) - (local_y * math.sin(theta))
            rotated_y = (local_x * math.sin(theta)) + (local_y * math.cos(theta))
            
            global_x = rotated_x + cx
            global_y = rotated_y + cy
            points.append((global_x, global_y))
            
        return points


    def GetData(self):
        if not self.abnormal:     
            if random.uniform(0,1) > 0.7:
                self.abnormal = True
                self.abnormal_time = self.iteration
                self.wind_direction = math.radians(random.uniform(0,360))
        else:
            if self.iteration - self.abnormal_time > 5:
                self.abnormal = False
                self.wind_direction = self.wave_direction

        self.wave_direction += (self._GetDirectionDelta()*self.wave_delta_multiplier)
        self.wind_direction += (self._GetDirectionDelta()*self.wind_delta_multiplier)
        self.wave_direction %= (2*math.pi)
        self.wind_direction %= (2*math.pi)

        if self.iteration % 10 == 0:
            prob = random.uniform(0,1)
            if prob < 0.5:
                self.state = "normal"
            elif prob < 0.75:
                self.state = "light"
            elif prob < 0.9:
                self.state = "medium"
            else:
                self.state = "heavy"

        match self.state:
            case "light":
                self.wave_speed = random.uniform(4,9)
                self.wind_speed = random.uniform(15,25)
            case "medium":
                self.wave_speed = random.uniform(9,16)
                self.wind_speed = random.uniform(25,40)
            case "heavy":
                self.wave_speed = random.uniform(16,30)
                self.wind_speed = random.uniform(40,70)            
            case _:
                self.wave_speed = random.uniform(1,4)
                self.wind_speed = random.uniform(5,15)

        k = math.sqrt((self.vessel_width/2)**2 + self.vessel_height**2)

        kk = random.uniform(k, 2*k)
        kk += self.vessel_height/2
        cx = kk*math.cos(self.wave_direction)
        cy = kk*math.sin(self.wave_direction)
        wave_point = self._GetPoints(cx, cy, 50, self.wave_direction, self.n_wave_sensor)

        kk = random.uniform(k, 2*k)
        kk += self.vessel_height/2
        cx = kk*math.cos(self.wind_direction)
        cy = kk*math.sin(self.wind_direction)
        wind_point = self._GetPoints(cx, cy, 50, self.wind_direction, self.n_wind_sensor)      

        self.iteration += 1
        if self.iteration == 131: 
            self.iteration = 0

        return json.dumps(
            {
                "wave" : {
                    "speed" : self.wave_speed,
                    "points" : wave_point
                },
                "wind" : {
                    "speed" : self.wind_speed,
                    "point" : wind_point
                }
            }
        )

        



    


        


    


    

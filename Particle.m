classdef Particle
    %PARTICLE Represents a particle
    %   Particle has different methods to assign and retrieve values and
    %   handle the right behaviour. There are weight functions and sensor
    %   data for every particle.
    
    properties
        Weight;
        X;
        Y;
        Phi;
        SensorLeft;
        SensorRight;
    end
    
    methods
        function obj = Particle(x, y, phi)
            %PARTICLE Construct an instance of this class
            obj.X = x;
            obj.Y = y;
            obj.Phi = phi;
            obj.Weight = 0.9; %initially has heighest weight
            obj.SensorRight = [-0.265 0.09]; %sensor right
            obj.SensorLeft = [-0.265 -0.09] ;%sensor left
        end
        
        function obj = update(obj, v, noise)
            %UPDATE update this particle with the given v vector
            temp = odometrie([obj.X obj.Y obj.Phi], v, noise);
            obj.X = temp(1);
            obj.Y = temp(2);
            obj.Phi = temp(3);
        end
        
        function obj = updateWeight(obj, weight)
            %UPDATEWEIGHT updates the weight of this particle
            obj.Weight = weight;
        end
        
        function obj = updatePosition(obj, x, y, phi)
            %UPDATEPOSITION Set the position of this particle manually
            obj.X = x;
            obj.Y = y;
            obj.Phi = phi;
        end
    
        function sensorPos = getSensorLeft(obj)
            %GETSENSORLEFT returns the position of the sensor in respect to
            %the actual position and orientation
            %   x'   =   cos(phi) sin(phi) * x
            %   y'   =  -sin(phi) cos(phi)   y
            %
            %
            x = obj.X + (cos(obj.Phi) * obj.SensorLeft(1) + -sin(obj.Phi) * obj.SensorLeft(2));
            y = obj.Y + (sin(obj.Phi) * obj.SensorLeft(1) + cos(obj.Phi) * obj.SensorLeft(2));
            sensorPos = [x y];
        end
        
        function sensorPos = getSensorRight(obj)
            %GETSENSORRIGHT returns the position of the sensor in respect to
            %the actual position and orientation
            x = obj.X + (cos(obj.Phi) * obj.SensorRight(1) + -sin(obj.Phi) * obj.SensorRight(2));
            y = obj.Y + (sin(obj.Phi) * obj.SensorRight(1) + cos(obj.Phi) * obj.SensorRight(2));
            sensorPos = [x y];
        end
    end
end


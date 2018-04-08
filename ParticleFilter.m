classdef ParticleFilter
    %PARTICLEFILTER Constructs a Particle Filter
    %   This Particle Filter runs concurrent and updates with the update
    %   method.
    
    properties
        NumberParticles;
        Particles;
        Weights;
        Map;
        Noise;
        Bounds;
    end
    
    methods
        function obj = ParticleFilter(numberParticles, bounds, noise)
            %PARTICLEFILTER Construct an instance of this class
            %   numberParticles is the number of Particles used
            %   bounds is the initial area on where to spawn the particles
            %   noise is the noise that we should add in an update step
            obj.NumberParticles = numberParticles;
            obj.Noise = noise;
            obj.Bounds = bounds;
            obj.Particles = [];
            obj.Weights = [];
            for x = 1 : obj.NumberParticles
                obj.Particles = [obj.Particles Particle(rand(1) * bounds(1), rand(1) * bounds(2), rand(1) * 2 * pi)];
                obj.Weights = [obj.Weights obj.Particles(x).Weight];
            end
            
        end
        
        function obj = update(obj, v, measurement, map)
            %UPDATE update this particle filter by a given step
            %   v is the update vector
            %   measurement is the measure of the real robot
            %   map is the grid map on which to check for the particle
            %       measurement
            for x = 1 : obj.NumberParticles
                obj.Particles(x) = update(obj.Particles(x), v, obj.Noise);
                % Looking at every particle
                % Check what this particle measures
                leftPos = checkBounds(obj, obj.Particles(x).getSensorLeft());
                if leftPos == 1
                    leftPos = map.getOccupancy(obj.Particles(x).getSensorLeft());
                end
                rightPos = checkBounds(obj, obj.Particles(x).getSensorRight());
                if rightPos
                    rightPos = map.getOccupancy(obj.Particles(x).getSensorRight());
                end
                % Check if this particle measures the same as the original
                % and update the weight accordingly
                if (leftPos == measurement(1)) && (rightPos == measurement(2))
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.9);
                elseif leftPos == measurement(1) || rightPos == measurement(2)
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.5);
                else
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.1);
                end
                obj.Weights(x) = obj.Particles(x).Weight;
            end
            % Resample if the particle filter becomes very bad
            if weightCheck(obj, 0.5)
                obj = resampleNormal(obj);
            end
            %end of update process
        end
        
        function ret = weightCheck(obj, check)
            %WEIGHTCHECK return a true or false boolean wether we need to
            %resample in case the weights are to bad. Specifically if in
            %the case N_eff = 1 / sum(w_i^2) and N_eff < a*N where a is our
            %check parameter (e.g. 0.5).
            for x = 1 : obj.NumberParticles
                w = 1/(obj.Weights(x) ^2);
            end
            ret = w < check * obj.NumberParticles;
        end
        
        function obj = resampleNormal(obj)
            %RESAMPLENORMAL does a resample on the particles with a normal
            %distibution and normal resmpling.
            w = 1/sum(obj.Weights) * obj.Weights;
            r = rand(numel(w), 1);
            for x = 1 : obj.NumberParticles
                if obj.Weights(x) < 0.5
                    y = 1;
                    %search for resampling particle with is at r(y) 
                    while y <= obj.NumberParticles
                        if r(x) > sum(w(1:y))
                            y = y+1;
                        else 
                            break;
                        end
                    end
                    if y > obj.NumberParticles %y is at end of particle so subtract one
                        y = y - 1;
                    end
                    %this is the particle on which we should resample
                    temp = obj.Particles(y);
                    %add noise to the particle where we spawn on
                    newX = temp.X + rand(1) * obj.Noise;
                    newY = temp.Y + rand(1) * obj.Noise;
                    newPhi = mod(temp.Phi + rand(1) * obj.Noise, 2*pi);
                    temp = updatePosition(temp, newX, newY, newPhi);
                    obj.Particles(x) = temp; %write new resampled position to particle
                    updateWeight(obj.Particles(x), 0.9); %update the weight of that particle
                end
            end
        end
        
        function ret = checkBounds(obj, coordinate)
            %   CHECKBOUNDS checks wether the coordinate is in the bounds
            ret = coordinate(1) > 0 && coordinate(2) > 0;
            ret = ret && coordinate(1) < obj.Bounds(1) && coordinate(2) < obj.Bounds(2);
        end
    end
end


classdef ParticleFilter
    %PARTICLEFILTER Constructs a Particle Filter
    %   This Particle Filter runs concurrent and updates with the update
    %   method.
    
    properties
        NumberParticles;
        Particles;
        InnerBounds;
        OuterBounds;
        Weights;
        Map;
        Noise;
    end
    
    methods
        function obj = ParticleFilter(numberParticles, bounds, innerBounds, outerBounds, noise)
            %PARTICLEFILTER Construct an instance of this class
            %   Detailed explanation goes here
            obj.NumberParticles = numberParticles;
            obj.InnerBounds = innerBounds;
            obj.OuterBounds = outerBounds;
            obj.Noise = noise;
            obj.Particles = [];
            obj.Weights = [];
            for x = 1 : obj.NumberParticles
                obj.Particles = [obj.Particles Particle(rand(1) * bounds(1), rand(1) * bounds(2), rand(1) * 2 * pi)];
                obj.Weights = [obj.Weights obj.Particles(x).Weight];
            end
            
        end
        
        function obj = update(obj, v, measurement)
            %UPDATE update this particle filter by a given step
            for x = 1 : obj.NumberParticles
                obj.Particles(x) = update(obj.Particles(x), v, obj.Noise);
                %look if this particle measures something
                %check left sensor first
                measureLeft = obj.Particles(x).getSensorLeft();
                measureRight = obj.Particles(x).getSensorRight();
                %check with map
                measuredBool = obj.Particles(x).X < 0 || obj.Particles(x).X > 10 || obj.Particles(x).Y < 0 || obj.Particles(x).Y > 10;% generell
                measuredBool = measuredBool || (measureLeft(1) < obj.InnerBounds(1,1) && measureLeft(1) > obj.OuterBounds(1,1)); %unten
                measuredBool = measuredBool || (measureLeft(1) > obj.InnerBounds(3,1) && measureLeft(1) < obj.OuterBounds(3,1)); %oben
                measuredBool = measuredBool || (measureLeft(2) < obj.InnerBounds(1,2) && measureLeft(2) > obj.OuterBounds(1,2)); %links
                measuredBool = measuredBool || (measureLeft(2) > obj.InnerBounds(3,2) && measureLeft(2) < obj.OuterBounds(3,2)); %rechts 
                measureLeft = measuredBool;

                measuredBool = obj.Particles(x).X < 0 || obj.Particles(x).X > 10 || obj.Particles(x).Y < 0 || obj.Particles(x).Y > 10;% generell
                measuredBool = measuredBool || (measureRight(1) < obj.InnerBounds(1,1) && measureRight(1) > obj.OuterBounds(1,1)); %unten
                measuredBool = measuredBool || (measureRight(1) > obj.InnerBounds(3,1) && measureRight(1) < obj.OuterBounds(3,1)); %oben
                measuredBool = measuredBool || (measureRight(2) < obj.InnerBounds(1,2) && measureRight(2) > obj.OuterBounds(1,2)); %links
                measuredBool = measuredBool || (measureRight(2) > obj.InnerBounds(3,2) && measureRight(2) < obj.OuterBounds(3,2)); %rechts 
                measureRight = measuredBool;
                if (measureLeft == measurement(1)) && (measureRight == measurement(2))
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.9);
                elseif measureLeft == measurement(1) || measureRight == measurement(2)
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.5);
                else
                    obj.Particles(x) = updateWeight(obj.Particles(x), 0.1);
                end
                obj.Weights(x) = obj.Particles(x).Weight;
            end
            %resampling
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
                    newX = temp.X + rand(1) * 0.2;
                    newY = temp.Y + rand(1) * 0.2;
                    newPhi = mod(temp.Phi + rand(1) * 0.2, 2*pi);
                    temp = updatePosition(temp, newX, newY, newPhi);
                    obj.Particles(x) = temp; %write new resampled position to particle
                    updateWeight(obj.Particles(x), 0.9); %update the weight of that particle
                end
            end
            %end of update process
        end
    end
end


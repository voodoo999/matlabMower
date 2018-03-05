clear all;
close all;
clc;
%%%PARAMETER
%anzahl der partikel im filter
numberParticles = 100;
%größe der map
bounds = [10, 10];
%der originale roboter
original = [5 5 0];
%update frequenz
updateRate = .5;
%noise
noise = 0.02;
%orientationNoise = 15; %10 grad
v = getV();
%generieren von N zufälligen partikeln
x = rand(numberParticles, 1) * bounds(1);
y = rand(numberParticles, 1) * bounds(2);
phi = rand(numberParticles, 1) * 2*pi;
particles = [x y phi]; %x;y;orientierung
%particle gewichte (normalisiert)
w = 1/numberParticles*ones(numberParticles,1);
%anzeigen
figure;
axis([0 bounds(1) 0 bounds(2)]);
hold on;
%weight: 1000*(1/numberParticles*ones(numberParticles,1)+0.0001
scatterParticles = scatter(particles(:,1),particles(:,2),5,'b','filled');
scatterOriginal = scatter(original(:,1), original(:,2),15,'g','filled');
scatterMean = scatter(sum(particles(:,1))/numberParticles,sum(particles(:,2))/numberParticles,15,'r','filled');
pause(1);

%lengthOfSimulation
maxTime = size(v,1) * updateRate;
%helper to find the right index in the v matrix of this simulation
index = 1;
for t = 1 : updateRate : maxTime
    v(index,3) = updateRate; %set the time to the V vector
    %move original
    original = kinModell(original, v(index,:));
    %shouldnt occure but if this is out of bound rotate around pi
    if original(1) < 0 || original(1) > bounds(1) || original(2) < 0 || original(2) > bounds(2)
        original(3) = mod((original(3) + pi), 2*pi);
    end
    %update the positions here for every particle
    for x = 1 : numberParticles
       temp = odometrie(particles(x,:), v(index,:), noise);
       %calc the new weight for this particle
       %if particle is out of bounds set weight to 0
       if temp(1) < 0 | temp(1) > bounds(1) | temp(2) < 0 | temp(2) > bounds(2)
           w(x) = 0; 
       end
       particles(x,:) = temp; %write updated position to the particle
    end
    %normalize the weight vector
    w = 1/sum(w) * w;
    %resample with a random vector
    r = rand(numel(w), 1);
    for x = 1 : numberParticles
        %resample the particles which weights are zero and sample them
        %accordingly to r
        if w(x) == 0 %if there is a function for w we should have a threshold
            y = 1;
            %search for respamling particle with is at r(y) 
            while y <= numberParticles
                if r(x) > sum(w(1:y))
                    y = y+1;
                else 
                    break;
                end
            end
            if y > numberParticles %y is at end of particle so subtract one
                y = y - 1;
            end
            %this is the particle wehere we should resample on
            temp = particles(y,:);
            %add noise to the particle where we spawn on
            temp = temp + rand(1,3) * 0.2;
            particles(x,:) = temp; %write new resampled position to particle
            w(x) = 1/numberParticles; %update the weight of that particle
        end
    end
    
    %plot and pause
    delete(scatterParticles);
    delete(scatterOriginal);
    delete(scatterMean);
    scatterParticles = scatter(particles(:,1),particles(:,2),5,'b','filled');
    scatterOriginal = scatter(original(:,1), original(:,2),15,'g','filled');
    scatterMean = scatter(sum(particles(:,1))/numberParticles,sum(particles(:,2))/numberParticles,10,'r','filled');
    pause(0.01);
    index = index + 1;
end


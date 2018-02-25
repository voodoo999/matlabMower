clear all;
close all;
clc;
%%%PARAMETER
%anzahl der partikel im filter
numberParticles = 10;
%größe der map
bounds = [10, 10];
%radabstand
radabstand = 0.3;
%radumfang
radumfang = 0.3;
%der originale roboter
original = [5;5;0];
%update frequenz
updateRate = 1;
%lengthOfSimulation
maxTime = 30;
%noise
noise = 0.2; %20 cm
orientationNoise = 15; %10 grad

%generieren von N zufälligen partikeln
particles = [rand(2,numberParticles) * bounds(1); rand(1,numberParticles) * 360];%x;y;orientierung
%particle gewichte (normalisiert)
w = 1/numberParticles*ones(numberParticles,1);
%anzeigen
figure;
axis([0 bounds(1) 0 bounds(2)]);
hold on;
scatterParticles = scatter(particles(1,:),particles(2,:),1000*(1/numberParticles*ones(numberParticles,1)+0.0001),'b','filled');
scatterOriginal = scatter(original(1,:), original(2,:),1000*(1/numberParticles)+0.0001,'g','filled');
scatterMean = scatter(sum(particles(1,:))/numberParticles,sum(particles(2,:))/numberParticles,1000*(1/numberParticles)+0.0001,'r','filled');
pause(1);

for t = 0 : updateRate : maxTime

    %update the positions here
    %for x = 1 : numberParticles
    %   newPos = nextPosition(leftWheel,rightWheel, x, y, theta, radabstand, time) %noch unklar!!!!
    %   particles(:,x) = newPos;
    %end
    %calculate the new weight
    %wie berechnen wir die neuen weights?
    %w = w/sum(w);
    %resample
    
    sampleNoise = [(rand(size(particles(1,:)))-0.5)*noise;(rand(size(particles(2,:)))-0.5)*noise;(rand(size(particles(3,:)))-0.5)*orientationNoise];
    particles = particles + sampleNoise;
    
    delete(scatterParticles);
    delete(scatterOriginal);
    delete(scatterMean);
    scatterParticles = scatter(particles(1,:),particles(2,:),1000*w+0.0001,'b','filled');
    scatterOriginal = scatter(original(1,:), original(2,:),1000*(1/numberParticles)+0.0001,'g','filled');
    scatterMean = scatter(sum(particles(1,:))/numberParticles,sum(particles(2,:))/numberParticles,1000*(1/numberParticles)+0.0001,'r','filled');
    pause(1);
end

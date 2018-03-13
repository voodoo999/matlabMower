close all;
clear all;
clc;
%PARAMETER
bounds = [10 10];
numberParticles = 1000;
original = Particle(5, 5, 0);

%display
figure;
axis([0 bounds(1) 0 bounds(2)]);
hold on;
lineX1 = [0.5; 9.5; 9.5; 0.5; 0.5];
lineY1 = [0.5; 0.5; 9.5; 9.5; 0.5];
%plot(lineX1, lineY1, 'black');
lineX2 = [1; 9; 9; 1; 1];
lineY2 = [1; 1; 9; 9; 1];
%plot(lineX2, lineY2, 'black');
fill(lineX1, lineY1, 'black');
fill(lineX2, lineY2, 'white');

outerBounds = [lineX1 lineY1];
innerBounds = [lineX2 lineY2];

pf = ParticleFilter(numberParticles, bounds, innerBounds, outerBounds, 0.1);

xCoordinates = zeros(1, numberParticles);
yCoordinates = zeros(1, numberParticles);
for x = 1 : numberParticles
    xCoordinates(x) = pf.Particles(x).X;
    yCoordinates(x) = pf.Particles(x).Y;
end


scatterParticles = scatter(xCoordinates, yCoordinates, 5, 'b', 'filled');
scatterOriginal = scatter(original.X, original.Y, 20, 'g', 'filled');
scatterMean = scatter(sum(xCoordinates)/numberParticles,sum(yCoordinates)/numberParticles,15,'r','filled');
pause(1);

timestep = 0.1;
v = [1 0 timestep]; %go straight
for t = 0 : timestep : 500
    original = original.update(v, 0);
    
    %check left sensor first
    %check left sensor first
    measureLeft = original.getSensorLeft();
    measureRight = original.getSensorRight();
    %check with map
    %check x position
    measuredBool = (measureLeft(1) < innerBounds(1,2) && measureLeft(1) > outerBounds(1,2)); %unten
    measuredBool = measuredBool || (measureLeft(1) > innerBounds(3,2) && measureLeft(1) < outerBounds(3,2)); %oben
    measuredBool = measuredBool || (measureLeft(2) < innerBounds(1,1) && measureLeft(2) > outerBounds(1,1)); %links
    measuredBool = measuredBool || (measureLeft(2) > innerBounds(3,1) && measureLeft(2) < outerBounds(3,1)); %rechts 
    measureLeft = measuredBool;
    
    measuredBool = (measureRight(1) < innerBounds(1,2) && measureRight(1) > outerBounds(1,2)); %unten
    measuredBool = measuredBool || (measureRight(1) > innerBounds(3,2) && measureRight(1) < outerBounds(3,2)); %oben
    measuredBool = measuredBool || (measureRight(2) < innerBounds(1,1) && measureRight(2) > outerBounds(1,1)); %links
    measuredBool = measuredBool || (measureRight(2) > innerBounds(3,1) && measureRight(2) < outerBounds(3,1)); %rechts 
    measureRight = measuredBool;
    
    pf = pf.update(v, [measureLeft measureRight]);
    xCoordinates = zeros(1, numberParticles);
    yCoordinates = zeros(1, numberParticles);
    for x = 1 : numberParticles
        xCoordinates(x) = pf.Particles(x).X;
        yCoordinates(x) = pf.Particles(x).Y;
    end
    
    if measureLeft && measureRight
        v = [-0.1 1 timestep];
    elseif measureLeft && not(measureRight)
        v = [0.5 0.1 timestep];
    elseif measureRight && not(measureLeft)
        v = [0.5 -0.1 timestep];
    else
        v = [0.5 0 timestep];
    end
    delete(scatterParticles);
    delete(scatterOriginal);
    delete(scatterMean);
    scatterParticles = scatter(xCoordinates, yCoordinates, 5, 'b', 'filled');
    scatterOriginal = scatter(original.X, original.Y, 20, 'g', 'filled');
    scatterMean = scatter(sum(xCoordinates)/numberParticles,sum(yCoordinates)/numberParticles,15,'r','filled');
    pause(0.01);
end
% This Script creates a Particle Filter
%
% The original Particle is green in the Map
% A normal Particle is blue
% The mean of all Particles is red
% The original Particles moves from the inside to the edge of the map 
% and then moves along the edge around the map.
%
% Sven Andresen (sven.andresen@student.uni-luebeck.de)
% 06.04.2018
%%
close all;
clear all;
clc;

%% PARAMETER
bounds = [14 14];
numberParticles = 1000;
original = Particle(5, 5, 0);

%% Loading the Map
map = load('map.mat');
map = map.map;

%% Display the map
figure('Name', 'PF Map');
axis([0 bounds(1) 0 bounds(2)]);
hold on;
show(map);

% %display
% lineX1 = [0.5; 9.5; 9.5; 0.5; 0.5];
% lineY1 = [0.5; 0.5; 9.5; 9.5; 0.5];
% lineX2 = [1; 9; 9; 1; 1];
% lineY2 = [1; 1; 9; 9; 1];
% %obstacles
% outerBounds = [lineX1 lineY1];
% innerBounds = [lineX2 lineY2];
% map = BinaryGridMap(bounds(1), bounds(2), [outerBounds innerBounds]);
% map.createFigure();

%% Create particle filter
pf = ParticleFilter(numberParticles, bounds, 0.15);

%% Display the Particles and original and mean
% Get Coordinates of Particle
xCoordinates = zeros(1, numberParticles);
yCoordinates = zeros(1, numberParticles);
for x = 1 : numberParticles
    xCoordinates(x) = pf.Particles(x).X;
    yCoordinates(x) = pf.Particles(x).Y;
end
% Create scatter variables and display
scatterParticles = scatter(xCoordinates, yCoordinates, 5, 'b', 'filled');
scatterMean = scatter(sum(xCoordinates)/size(xCoordinates, 2),sum(yCoordinates)/size(yCoordinates, 2),15,'r','filled');
scatterOriginal = scatter(original.X, original.Y, 20, 'g', 'filled');
pause(1);

%% Start particle update step
timestep = 0.1;
v = [1 0 timestep]; %go straight initially
for t = 0 : timestep : 500
    original = original.update(v, 0);
    % Check what we originally sense
    leftPos = map.getOccupancy(original.getSensorLeft());
    rightPos = map.getOccupancy(original.getSensorRight());
    % Update the particle Filter and resample
    pf = pf.update(v, [leftPos rightPos], map);
    % Get updates positions
    xCoordinates = zeros(1, numberParticles);
    yCoordinates = zeros(1, numberParticles);
    for x = 1 : numberParticles
        xCoordinates(x) = pf.Particles(x).X;
        yCoordinates(x) = pf.Particles(x).Y;
    end
    % update the driving according to the measured data
    if leftPos && rightPos
        v = [0.5 0 timestep];
    elseif leftPos && not(rightPos)
        v = [0.5 -0.1 timestep];
    elseif rightPos && not(leftPos)
        v = [0.5 0.1 timestep];
    else
        v = [-0.1 1 timestep];
    end
    % update the scatte
    delete(scatterParticles);
    delete(scatterMean);
    delete(scatterOriginal);
    scatterParticles = scatter(xCoordinates, yCoordinates, 5, 'b', 'filled');
    scatterMean = scatter(sum(xCoordinates)/size(xCoordinates, 2),sum(yCoordinates)/size(yCoordinates, 2),15,'r','filled');
    scatterOriginal = scatter(original.X, original.Y, 20, 'g', 'filled');
    pause(0.01);
end
% This script generates an occupancy grid map
%
% 1: Grass
% 0: No Grass
%
% Nils Rottmann (Nils.Rottmann@rob.uni-luebeck.de
% 26.03.2018

%%
clear all
close all
clc

%% Generate the map
name = 'map';           % Name of the map when saved
width = 14;             % width of the map, in [m]
height = 14;            % height of the map, in [m]
resolution = 10;        % cells per metre

map = robotics.BinaryOccupancyGrid(width,height,resolution);

%% Define occupancies (grass), using rectangulars
n = 2;              % number of rectangulars
pu = cell(2,1);     % bottom corner of rectangulars
po = cell(2,1);     % upper corner of rectangulars

pu{1} = [2 2];
po{1} = [7 12];
pu{2} = [7 2];
po{2} = [12 8];

for i=1:1:n
    dx = po{i}(1) - pu{i}(1);
    dy = po{i}(2) - pu{i}(2);
    for j=0:1:(dx*resolution)
        for k=0:1:(dy*resolution)
            x = pu{i}(1) + (j/resolution);
            y = pu{i}(2) + (k/resolution);
            setOccupancy(map,[x y],1);
        end
    end
end

show(map);

%% Plot the map and save it
% show(map);
save(name,'map');
% This is the simulation for the lawn mower robot movement. It will show up
% the position of the robot while it is moving randomly. It will also
% calculate the estimated position based on odometrie, IMU sensors and the
% sensor fusion of them via a Kalman Filter.
%
% Date: 28.03.18
% Author: Rico Klinckenberg

%% Clear Screen
close all;
clear all;
clc;

%% Variables
posKin = [0; 0; 0];               %Current position for the kinematic Modell
pos0 = [0; 0; 0];                 %Position of last time step
posOdo = [0; 0; 0];               %Current estimated position for the odometrie
posIMU = [0; 0; 0; 0; 0; 0];      %Current estimated position for IMU
%Kalman Filter variables
posKalman = [0; 0];              %Current estimated position for KF
P = [];                         %Covariance of last time step
Q = [];                         %Process noise covariance of last time step
R = [];                         %Measurment noise covariance of last time step

%% Paramaters
velocity = 0;                   %Initial velocity of robot
w = 0;                          %Initial orientation of robot
flag=false;                     %flag for first iteration of simulation
dt = .1;                        %duration of time steps in [s]
counter = 60;                    %Number of iterations = counter/dt;
sigmaOdometrie = .0003;           %Sigma for normal distribution (odometrie)
sigmaIMU = .1;                 %Sigma for normal distribution (IMU)

%Paramers for IMU
velIMU = [0; 0; 0];               %Initial x,y and phi velocity for IMU
velPhi = 0;                     %Initial angular velocity for IMU
accIMU = [0; 0];                 %Initial x acceleration for IMU

%Matrices containing the calculated points
plotPosKin = [];
plotPosOdo = [];
plotPosIMU = [];
plotPosKal = [];

%% Simulation
figure;
hold on;
for c = 0:+dt:counter
    %Berechnen der letzten Geschwindigkeiten/Beschleunigungen durch Positionsänderung für
    %IMU
    velIMU0 = velIMU;
    velX = (posKin(1,1)-pos0(1,1))/dt;
    velY = (posKin(2,1)-pos0(2,1))/dt;
    velPhi = (posKin(3,1)-pos0(3,1))/dt;
    accX = (velX - velIMU0(1,1))/dt;
    accY = (velY - velIMU0(2,1))/dt;
    velIMU = [velX; velY; velPhi];
    accIMU = [accX; accY];
    
    % Calculate new random velocity and orientation.
    velocity = rand(1)*3;
    w = mod(((rand(1)*(2*pi - -2*pi) + -2*pi) + w),w);
    
    % Input vectors for models
    u = [velocity; w]; %Odometrie
    a = [accX; accY; velPhi];  %IMU
    
    %Abspeichern letzter Position für Änderungsberechnung im nächsten
    %Schritt
    pos0 = posKin;
 
    
    %Berechnen der neuen Positionen der Modelle
    [posKin,vL,vR]=kinModell(posKin, u, dt);
    posOdo = odometrie(posOdo, [vL; vR], sigmaOdometrie, dt);
    posIMU = imuModell(posIMU, a, sigmaIMU, dt);
    
    Z = [posOdo(1,1); posOdo(2,1); posIMU(1,1); posIMU(2,1)];
    sigmaKF = [sigmaOdometrie sigmaOdometrie sigmaIMU sigmaIMU sigmaIMU];
    [posKalman, P, Q, R]=kalmanFilter(posKalman, Z , sigmaKF, flag, P, Q, R);
    
    %% Plot new points
    
    %   Add new points to plot
    plotPosOdo=[plotPosOdo [posOdo(1,1); posOdo(2,1)]];
    plotPosKin=[plotPosKin [posKin(1,1); posKin(2,1)]];
    plotPosIMU=[plotPosIMU [posIMU(1,1); posIMU(2,1)]];
    plotPosKal=[plotPosKal [posKalman(1,1); posKalman(2,1)]];
    plot(plotPosKin(1,:), plotPosKin(2,:), 'g');
    plot(plotPosOdo(1,:), plotPosOdo(2,:), 'r');
    plot(plotPosIMU(1,:), plotPosIMU(2,:), 'b');
    plot(plotPosKal(1,:), plotPosKal(2,:), 'black');
    flag=true;
    pause(.02);
end
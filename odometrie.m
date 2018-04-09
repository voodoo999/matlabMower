function [p1] = odometrie(p0, vel, sigmaOdometrie, dt)
    % This is the simulated odometrie model for the lawn mower robot. It
    % receives both velocitys of the two wheels from the differential drive of the robot
    % vel = [vL; vR] and calculates the new position of the robot including a
    % random gauss noise. The kinematics are based on a
    % differential drive system.
    %
    % Equation:
    %   v = (vL-vR)/2;
    %   w = (vR+vL)/(2*L);
    %
    %
    % Syntax:
    %   [p1] = odometrie(p0, vL, vR, sigmaOdometrie, dt)
    %
    % Input:
    %   p0 : current position of robot, [x y phi]^T
    %   vel: input vector containing both wheel velocitys, [vL vR]^T
    %   sigmaOdometrie: sigma of the random gauss noise
    %   dt : size of timestep for this input
    %
    % Output:   
    %   p1 : new calculated position after movement step
    %
    % Date: 28.03.18
    % Author: Rico Klinckenberg (rico.klinckenberg@student.uni-luebeck.de)
    %% Check for correct input dimensions
        if (size(p0) ~= [3 1])
            error('Size of input pos0 is not correct!')
        end
        if (size(vel) ~= [2 1])
            error('Size of input u is not correct!')
        end
        if (size(sigmaOdometrie) ~= [1 1])
            error('Size of input SigmaOdometrie is not correct!')
        end
        if (size(dt) ~= [1 1])
            error('Size of input dt is not correct!')
        end
    
    %% Parameters
    mu = 0;                     %mu for normal distribution
    L = 0.1575;                 %Half of the axis length, in [m]
    
    %% Calculating new velocitys for kinematic model
    
    r = mvnrnd(mu, sigmaOdometrie, 2);      %normal distribution   
    vL = vel(1, 1) + r(1);                  %adding noise to left wheel velocity 
    vR = vel(2, 1) + r(2);                  %adding noise to right wheel velocity
    
    v = (vL-vR)/2;                          %calculating robot velocity
    w = (vR+vL)/(2*L);                      %calculating robot angular velocity
    
    [p1] = kinModell(p0, [v; w], dt);        %new position calculating with kinematic model.
    


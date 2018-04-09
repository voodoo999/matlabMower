function [p1, vL, vR] = kinModell(p0, u, dt)
    % This is the simulated kinematic model and odometrie for the lawn mower robot. It
    % receives the vector u = [v w] as input with v as the velocity and w
    % as the angular velcoity of the robot. The kinematics are based on a
    % differential drive system.
    %
    % Equation:
    %   dx/dt = cos(phi) * v
    %   dy/dt = sin(phi) * v
    %   dphi/dt = w
    %
    %   v = (vR - vL)/2
    %   w = (L*w - v)
    %   -> vL = L*w - v
    %   -> vR = v + L*w
    %   -> lR_odometrie = vR*dt
    %   -> lL_odometrie = vl*dt
    %
    %
    % Syntax:
    %   [p1, vL, vR] = kinModell(p0, u, dt)
    %
    % Input:
    %   p0 : current position of robot, [x y phi]^T
    %   u : input vector, [v w]^T
    %   dt : size of timestep for this input
    %
    % Output:   
    %   p1 : new calculated position after movement step
    %   vL : velocity from left wheel
    %   vR : velocity from by right wheel
    %
    % Date: 28.03.18
    % Author: Rico Klinckenberg (rico.klinckenberg@student.uni-luebeck.de)
    
    %% Check for correct input dimensions
        if (size(p0) ~= [3 1])
            error('Size of input pos0 is not correct!')
        end
        if (size(u) ~= [2 1])
            error('Size of input u is not correct!')
        end
        if (size(dt) ~= [1 1])
            error('Size of input dt is not correct!')
        end
    
    %% Parameters
    L = 0.1575;              %Half of the axis length, in [m]
    mu = 0;                  %mu for normal distribution
    %% Kinematic Model & Odometrie
    v = u(1,1);                 % Velocity of robot
    w = u(2,1);                 % Angular velocity of robot
    
    % Handle singularity (w=0)
    if (w < 10^(-3))
        phi0 = p0(3);
        p1 = p0 + [v*cos(phi0)*dt; v*sin(phi0)*dt; 0];
    % w != 0
    else
        phi0 = p0(3);
        phi1 = phi0 + w*dt;
        vw = v/w;   
        p1 = [p0(1) + vw*(sin(phi1)-sin(phi0)); p0(2) + vw*(cos(phi0)-cos(phi1)); phi1];
    end
    
    %% Wheel velocitys (kinematic model)
    vL = v+L*w;      %velocity left wheel
    vR = L*w-v;     %velocity right wheel
end


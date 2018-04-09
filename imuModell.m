function [p1] = imuModell(p0, a, sigma, dt)
    % This is the simlated IMU model for the lawn mower robot including a
    % random gauss noise. It receives the vector a = [accX accY velPhi]
    % with the translatoric accelerations and angular velocity as input.
    %
    % Equation:
    %   vel1 = vel0 + acc1  
    %   p1 = p0 + vel1;
    %   w = velPhi
    %
    % Syntax:
    %   [p1] = imuModell(p0, a, sigma, dt)
    %
    % Input:
    %   p0 : current position of roboter: [x y phi velX velY velPhi]^T
    %   a : current IMU sensor input: [accX accY velPhi]^T
    %   sigma : sigma of gauss distribution for odometrie model
    %   dt : duration of last time step
    %
    % Output:
    %    p1 : new calculated position after movement step [x y phi velX velY velPhi]
    %
    % Date: 28.03.18
    % Author: Rico Klinckenberg
    
    %% Check for correct input dimensions
        if (size(p0) ~= [3 1])
            error('Size of input pos0 is not correct!')
        end
        if (size(a) ~= [3 1])
            error('Size of input a is not correct!')
        end
        if (size(sigma) ~= [1 1])
            error('Size of input sigma is not correct!')
        end
        if (size(dt) ~= [1 1])
            error('Size of input dt is not correct!')
        end
    
    %% Parameters
        mu = 0;             %mu for normal gauss distribution
        
    %% IMU Model
    r = mvnrnd(mu, sigma, 3);
    %Add gauss noise to sensor inputs
    accX = a(1,1)+r(1);
    accY = a(2,1)+r(2);
    velPhi = a(3,1)+r(3);
    
    %Calculate velocitys
    velX = p0(4,1) + accX*dt;
    velY = p0(5,1) + accY*dt;
    
    %Calculate new position
    p1 = [p0(1,1)+velX*dt; p0(2,1)+velY*dt; p0(3,1)+velPhi*dt; velX; velY; velPhi];

end
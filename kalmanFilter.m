function [x_estimate, P_estimate, Q , R] = kalmanFilter(x, Z, sigma, flag, P, Q, R)
    % This is the Kalman Filter which fuses both sensor inputs from
    % odometrie and IMU of the lawn mower robot. Both sensors are providing
    % estimated new positions which are fused to an more accurate estimated
    % positon.
    %
    % Equations:
    %   Predict
    %      x_hat = A * x
    %      P_hat = A * P * A^T + Q
    % 
    %   Measurment
    %       S = H * P_hat * H^T + R
    %       K = (P_hat * H^T)*S^-1
    %       x_estimate = x_hat + K*(z-H*x_hat)
    %       P_estimate = P_hat - K * S * K^T
    %
    % Syntax
    %   [x_estimate, P_estimate, Q, R] = kalmanFilter(x, z, sigma, flag, P, Q, R)
    %
    % Input
    %   x = last estimated position [x y]^T
    %   z = last measurments from odometrie and IMU 
    %       [x_Odometrie y_Odometrie x_IMU y_IMU]^T
    %   sigma = sigmas of both sensors [sigmaOdometrie sigmaIMU]^T
    %   flag = flag shows if this is the first round of KF
    %   P = last calculated estimated P matrice
    %   Q = last calculcated Q matrice
    %   R = last calculcated R matrice
    %
    % Output
    %   x_estimate = new estimated position after sensor fusion
    %   P_estimate = new estimated P matrice after sensor fusion
    %   Q = new calculcated Q matrice
    %   R = R matrice. Has to be given back to simulation.
    %
    % Date: 28.03.2018
    % Author: Rico Klinckenberg (rico.klinckenberg@student.uni-luebeck.de)
    %% Parametrs
    A=  [1 0;               %A is 2x2 matrix (state transition matrix)
         0 1];

    H = [0.7 0;             %H is 4x2 matrix (sensor model matrice) 
         0 0.7;
         0.3 0;
         0 0.3];
         

    if flag == false        %generate new P, Q, R and H matrices if this is first round
        
    P = [100 0;             %inital P matrix
         0 100];
    
    R = [sigma(1) 0 0 0;    %inital R matrix (Measurment noise)
         0 sigma(2) 0 0;
         0 0 sigma(3) 0;
         0 0 0 sigma(4)];

    Q=ones(2,2)*0.8;        %inital Q matrix  (Process Noise Covariance)
    
    end
  
    %% The Kalman Filter
    x_hat = A*x;
    P_hat = A*P*A.' + Q;
    
    S = H*P_hat*H.' + R;
    K = (P_hat*H.')/S;
    x_estimate = x_hat + K*(Z-H*x_hat);
    P_estimate = P_hat - K*S*K.';
end


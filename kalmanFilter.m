function [pos_estimate, P_estimate, Q , R] = kalmanFilter(pos, u, sigma, flag, P, Q, R)
    dt=.2;
    pos
    phi=pos(2,1);
    u = u.';

    %L
    L = 100;
    
    
    %state = [x y yaw x' y' yaw' x'' y'' yaw'']
    %u vector = [v yaw accX accY velYaw]

    %A is 9x9 matrix
    A=  [1 0 0 dt 0 0 (dt*dt)/2 0 0;
         0 1 0 0 dt 0 0 (dt*dt)/2 0;
         0 0 1 0 0 dt 0 0 (dt*dt)/2;
         0 0 0 1 0 0 dt 0 0;
         0 0 0 0 1 0 0 dt 0;
         0 0 0 0 0 1 0 0 dt;
         0 0 0 0 0 0 1 0 0;
         0 0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 0 1];
    %B must be 9x5 to get a 9x1 vector in step 1
    B =     [dt*cos(phi) 0 0 0 0;
             dt*sin(phi) 0 0 0 0;
             0 1 0 0 0;
             0 0 dt 0 0;
             0 0 0 dt 0;
             0 0 0 0 1;
             0 0 1 0 0;
             0 0 0 1 0;
             0 0 0 0 0];
    %H
    H = [0 0 0 0 0 0 0 0 0;
         0 0 1 0 0 0 0 0 0;
         0 0 0 0 0 0 1 0 0;
         0 0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 0 1];
     
    if flag == false
    %k-1 Position and Covariance
    P = [L 0 0 0 0 0 0 0 0;
         0 L 0 0 0 0 0 0 0;
         0 0 L 0 0 0 0 0 0;
         0 0 0 L 0 0 0 0 0;
         0 0 0 0 L 0 0 0 0;
         0 0 0 0 0 L 0 0 0;
         0 0 0 0 0 0 L 0 0;
         0 0 0 0 0 0 0 L 0;
         0 0 0 0 0 0 0 0 L];
     
    % Measurment noise
    R = [sigma(1) 0 0 0 0;
         0 sigma(2) 0 0 0;
         0 0 sigma(3) 0 0;
         0 0 0 sigma(4) 0;
         0 0 0 0 sigma(5)];
    %Process Noise Covariance
    Q = [L 0 0 0 0 0 0 0 0;
         0 L 0 0 0 0 0 0 0;
         0 0 L 0 0 0 0 0 0;
         0 0 0 L 0 0 0 0 0;
         0 0 0 0 L 0 0 0 0;
         0 0 0 0 0 L 0 0 0;
         0 0 0 0 0 0 L 0 0;
         0 0 0 0 0 0 0 L 0;
         0 0 0 0 0 0 0 0 L];
    end
  
    %1) Project the state ahead
    x_hat = A*pos + B*u;
    %2) Project the coviariance ahead
    P_hat = A*P*A.' + Q;
    % Estimate Measurement prediction covariance
    S = H*P_hat*H.' + R;
    %3) Compute Kalman Gain
    K = (P_hat*H.')/(H*P_hat*H.' + R);
    % Compute innovation
    z = H*x_hat + u;
    r = z - H*x_hat;
    %4) Update state estimate
    pos_estimate = x_hat + K*(z-H*x_hat);
    %5) Update the covariance
    P_estimate = P_hat - K*S*K.';
end


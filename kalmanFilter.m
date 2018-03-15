function [pos_estimate] = kalmanFilter(pos, z, u)
        
    %Variance of sensors
    sigmaOdoLeft = 0.3;
    sigmaOdoRight = 0.3;
    sigmaIMUXtrans = 0.03;
    sigmaIMUYtrans = 0.03;
    sigmaIMUYawtrans = 0.03;
    
    %A
    A=[1 0 0; 0 1 0; 0 0 1];
    %B
    B;
    %k-1 Position and Covariance
    P=[1 0 0;0 1 0;0 0 0];
    % Measurment noise
    R = [sigmaOdoLeft 0 0 0 0;
        0 sigmaOdoRight 0 0 0;
        0 0 sigmaIMUXtrans 0 0;
        0 0 0 sigmaIMUYtrans 0;
        0 0 0 0 sigmaIMUYawtrans];
    %Process Noise Covariance
    Q = ;
  
    %1) Project the state ahead
    pos_hat = A*pos + B*u;
    %2) Project the coviariance ahead
    P_hat = A*P*A.' + Q;
    % Estimate Measurement prediction covariance
    S = H*P_hat*H.' + R,
    %3) Compute Kalman Gain
    K = (P_hat*H.')/(H*P_hat*H.' + R);
    % Compute innovation
    r = z - H*x_hat;
    %4) Update state estimate
    pos_estimate = pos_hat + K*(z-H*x_hat);
    %5) Update the covariance
    P_estimate = P_hat - K*S*K.';
end


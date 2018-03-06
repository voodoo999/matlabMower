function [pos] = odometrie(pos_old, v, sigma)
    %normal distribution around 0 with sigma
    mu = 0;
    r = mvnrnd(mu, sigma, 2);
    v(1,1) = v(1,1) + r(1);
    v(1,2) = v(1,2) + r(2);
    
    pos = kinModell(pos_old, v);
end


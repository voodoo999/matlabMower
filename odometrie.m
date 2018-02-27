function [pos] = odometrie(pos_old, v)

    v(1,1) = v(1,1)*rand(1);
    v(1,2) = v(1,2)*rand(1);
    
    pos = zeros(1,3);
    
    achsenlaenge = 0.5;
    w = (v(1,1)-v(1,2))/achsenlaenge;
    velocity = (v(1,1)+v(1,2))/2;
    
    pos(1,1) = pos_old(1,1) + velocity*cos(w*.1);
    pos(1,2) = pos_old(1,2) + velocity*sin(w*.1);
    pos(1,3) = pos_old(1,3) + w;

end

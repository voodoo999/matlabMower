function [pos] = imuModell(pos_old, a)
    t=a(1,4);
    accX = a(1,1)+rand(1)*0.03;
    accY = a(1,2)+rand(1)*0.03;
    accYaw = atan(accX/-accY);
    
    velX = accX*t;
    velY = accY*t;
    velYaw = accYaw*t;

    pos = [pos_old(1,1)+velX*t pos_old(1,2)+velY*t pos_old(1,3)+velYaw*t];

end
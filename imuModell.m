function [pos] = imuModell(pos_old, a)
    R=2;
    t=a(1,4);
    velocityX = a(1,1)*t+(1/2)*a(1,1)*t*t;
    velocityY = a(1,2)*t*(1/2)*a(1,2)*t*t;
    phi=a(1,3);

    pos = [pos_old(1,1)+velocityX*2*cos(phi)
            pos_old(1,2)+velocityY*2*sin(phi)
                a(1,3)];

end
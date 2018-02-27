function [pos] = imuModell(pos_old, a)
    pos = zeros(1,3);
    a(1,1) = a(1,1)+rand(1);
    a(1,2) = a(1,2)+rand(1);
    try
        velocityX = load('velocityX.mat', 'velocityX');
        velocityY = load('velocityY.mat', 'velocityY');
    end
    
    if  exist('velocityX.mat','file') == 0
        velocityX = 0;
        velocityY = 0;
    else 
        velocityXhat = load('velocityX.mat', 'velocityX');
        velocityX = struct2array(velocityXhat);
        velocityX = velocityX+a(1,1);
        velocityYhat = load('velocityY.mat', 'velocityY');
        velocityY =  struct2array(velocityYhat);
        velocityY = velocityY+a(1,2);
    end
        
    pos(1,1) = pos_old(1,1) + velocityX*cos(a(1,3));
    pos(1,2) = pos_old(1,2) + velocityY*sin(a(1,3));
    pos(1,3) = a(1,3);
    save('velocityX.mat','velocityX');
    save('velocityY.mat','velocityY');

end
function [pos] = imuModell(pos_old, a)
    %Delta t
    t=a(1,4);
    %Beschleunigungen mit Messfehler versehen
    accX = a(1,1)+rand(1)*0.03;
    accY = a(1,2)+rand(1)*0.03;
    accYaw = a(1,3)+rand(1)*0.03;
    
    %Geschwindigkeiten berechnen
    velX = accX*t;
    velY = accY*t;
    velYaw = accYaw*t;
    
    %Neue Position berechnen
    pos = [pos_old(1,1)+velX*t pos_old(1,2)+velY*t pos_old(1,3)+velYaw*t];

end
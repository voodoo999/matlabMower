function [pos] = imuModell(pos_old, a)
    %Delta t
    t=a(1,4);
    %Beschleunigungen mit Messfehler versehen
    accX = a(1,1)+rand(1)*0.2;
    accY = a(1,2)+rand(1)*0.2;
    velYaw = a(1,3)+rand(1)*0.2;
    
    %Geschwindigkeiten berechnen
    velX = pos_old(1,4) + accX*t;
    velY = pos_old(1,5) + accY*t;
    
    %Neue Position berechnen
    pos = [pos_old(1,1)+velX*t pos_old(1,2)+velY*t pos_old(1,3)+velYaw*t];

end
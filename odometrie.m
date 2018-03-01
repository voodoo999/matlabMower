function [pos] = odometrie(pos_old, v)
    %Radius Achsenlaenge
    L = 0.1575;
    %Geschwindigkeit Roboter
    vel = v(1,1);
    %Winkelgeschwindigkeit
    w = v(1,2);
    %delta t, Zeit seit letztem Schritt
    t = v(1,3);
    %Radgeschwindigkeiten
    vleft = vel+L*w +rand(1)*0.03;
    vright = L*w-vel + rand(1)*0.03;
    
    %Strecke links, rechts
    l_L = vleft*t;
    l_R = vright*t;
    
    %Änderung Strecke
    delta_s = (l_R - l_L)/2;
    
    %Änderung Orientierung
    delta_phi = (l_R+l_L)/(2*L);
    
    %Neue Position berechnen.
    pos(1,1) = pos_old(1,1) + delta_s*cos(delta_phi);
    pos(1,2) = pos_old(1,2) + delta_s*sin(delta_phi);
    pos(1,3) = pos_old(1,3) + delta_phi;

end


function [pos] = odometrie(pos_old, v, noiseFactor)
    %Radius Achsenlaenge
    L = 0.1575;
    %Geschwindigkeit Roboter
    vel = v(1,1);
    %Winkelgeschwindigkeit
    w = v(1,2);
    %delta t, Zeit seit letztem Schritt
    t = v(1,3);
    %Radgeschwindigkeiten
    vleft = vel+L*w +rand(1)*noiseFactor;
    vright = L*w-vel +rand(1)*noiseFactor;
    
    %Strecke links, rechts
    l_L = vleft*t;
    l_R = vright*t;
    
    %�nderung Strecke
    delta_s = (l_R - l_L)/2;
    
    %�nderung Orientierung
    delta_phi = mod((l_R+l_L)/(2*L) + pos_old(1,3), 2*pi);
    
    %Neue Position berechnen.
    pos(1,1) = pos_old(1,1) + delta_s*cos(delta_phi);
    pos(1,2) = pos_old(1,2) + delta_s*sin(delta_phi);
    pos(1,3) = delta_phi;

end


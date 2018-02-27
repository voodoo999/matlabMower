function [pos] = kinModell(pos_old, v)
    t=v(1,3);
    xpos = pos_old(1,1);
    ypos = pos_old(1,2);
    phi = pos_old(1,3);
    vleft = v(1,1)
    vright = v(1,2)
    
    R = (vleft+vright)/(2*(vleft-vright));
    achsenlaenge = 0.5;
    w = (vright-vleft)/achsenlaenge;
    
    ICC = [(xpos - R*sin(phi)) (ypos + R*cos(phi))];

    pos = ([cos(w*t) -sin(w*t) 0; sin(w*t) cos(w*t) 0; 0 0 1]*[xpos -  ICC(1,1); ypos - ICC(1,2); 0]) +[ICC(1,1);ICC(1,2);w*t];

end


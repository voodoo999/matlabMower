function [y] = path(x, ab)

    if ab == 0
        y=x.^4-5*x.^2;
    elseif ab == 1
        y=4*x.^3-10*x;
    elseif ab == 2
        y=12*x.^2-10;
    end


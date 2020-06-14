% Linear Regression
% x = x values
% y = y values
function [a,b] = lreg(x,y)

    n = size(x,1);
    x_bar = mean(x);
    y_bar = mean(y);
    
    s_x = std(x);
    s_y = std(y);
    
    c_top = sum(((x - x_bar) .* (y - y_bar)));
    c_bot = (n-1) * s_x * s_y;
    r_xy = c_top/c_bot;
    
    a = r_xy * s_y / s_x;
    b = y_bar - a*x_bar;

end
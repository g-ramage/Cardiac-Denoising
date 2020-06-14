% NM simplex reflection
% alpha = reflection constant
% x     = simplex vertex coordinates
function xr = nm_reflect(alpha, x)

    if alpha < 0
        xr = x(1);
        return;
    end

    c = centroid(x);
    xr = c + alpha*(c - x(1));
    
    if abs(xr) > 1
        xr = nm_reflect((alpha - 0.1), x);
    end
        
end
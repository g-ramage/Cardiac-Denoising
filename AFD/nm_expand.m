% NM simplex expansion
% gamma = expansion constant
% x     = simplex vertex coordinates
function xe = nm_expand(gamma, x)

    if gamma < 1
        xe = x(1);
        return;
    end
    
    c = centroid(x);
    xe = c + gamma*(x(1) - c);
    
    if abs(xe) > 1
        xe = nm_expand((gamma - 0.1), x);
    end

end
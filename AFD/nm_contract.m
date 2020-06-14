% NM simplex contraction
% beta = reflection constant
% x     = simplex vertex coordinates
function xc = nm_contract(beta, x)

    if beta > 1
        xc = x(1);
        return;
    end

    c = centroid(x);
    xc = c + beta*(x(1) - c);
    
end
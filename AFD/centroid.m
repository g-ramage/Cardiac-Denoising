% NM Simplex Centroid Calculation
% x = simplex vertex coordinates
function c = centroid(x)

    N = size(x,2) - 1;
     
    c = 1/N * sum(x(2:N+1));

end
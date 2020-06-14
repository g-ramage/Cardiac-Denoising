% NM Optimisation Sort
% F = values of f(x)
% x = simplex vertex coordinates
function [F_out, x_out] = re_sort(F, x)

    [F_out, idx] = sort(F, 'descend');
    x_out = [x(idx(1)), x(idx(2)), x(idx(3))];

end
% give signal power of X
% X[1xN] = signal
function [p, pdB] = spow(X)
    
    N = size(X,2);
    X2 = (X .* X);
    p = 1/N * sum(X2);
    pdB = 20 * log10(p);

end
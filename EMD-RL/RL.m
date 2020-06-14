% Riemann Liouville filter
% f[1xN] = filtered signal
% alpha  = order
% W      = window length for K[n]
% x[1xN] = input signal
function f = RL(alpha, W, x)

    %N = size(x,2);
    K = zeros(1,W);
    for n = 1:W
       K(n) =  n^(alpha - 1) / gamma(alpha);
    end
    f = conv(x, K);

end
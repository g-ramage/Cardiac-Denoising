% AFD function
% a = a_n
% N = no. samples
function d_n = dn(a, N)

    d_n = zeros(1,N);
    k = 0;
    for t = 0:(2*pi/N):(2*pi - 2*pi/N)
        k = k+1;
        top = exp(1i*t) - a;
        bot = sqrt(1 - (abs(a))^2);
        d_n(k) = top/bot;
    end

end
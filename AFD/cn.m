% AFD function
% a = a_n
% N = no. samples
function c_n = cn(a, N)

    c_n = zeros(1,N);
    k = 0;
    for t = 0:(2*pi/N):(2*pi - 2*pi/N)
        k = k+1;
        top = 1 - (conj(a)*exp(1i*t));
        bot = exp(1i*t) - a;
        c_n(k) = top/bot;
    end

end
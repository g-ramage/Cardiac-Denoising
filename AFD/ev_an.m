% AFD evaluator function
% a = a_n
% N = no. samples
function e_n = ev_an(a, N)

    e_n = zeros(1,N);
    k = 0;
    for t = 0:(2*pi/N):(2*pi - 2*pi/N)
        k = k+1;
        top = sqrt(1 - (abs(a)^2));
        bot = 1 - conj(a)*exp(1i * t);
        e_n(k) = top/bot;
    end

end
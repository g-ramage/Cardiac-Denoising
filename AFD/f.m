% Nelder Mead Optimisation for AFD max function
% G = G_n
% x = complex number on unit disc
function fx = f(G, x)

    N = size(G,2);
    e_x = ev_an(x, N);
    fx = abs(AFD_fun(G, e_x))^2;

end
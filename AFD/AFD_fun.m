% AFD inner product
% G = G_n
% e = evaluator
function out = AFD_fun(G, e)

    N = size(G,2);
    out = conj(e * (G')) * (1/N);

end
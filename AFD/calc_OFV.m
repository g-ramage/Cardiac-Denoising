% AFD energy convergence
% S    = noisy signal
% En   = AFD component total energy
% SNRe = estimated SNR
function OFV = calc_OFV(S, En, SNRe)

    term1 = (norm(S)^2)/En;
    term2 = 1 + (1/(10^(SNRe/10)));
    OFV = abs(term1 - term2);

end
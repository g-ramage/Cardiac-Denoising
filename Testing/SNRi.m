% function to calculate SNR improvement
% x[n]  = original signal
% xr[n] = reconstructed signal
% y[n]  = noisy signal
function SNRimp = SNRi(x, xr, y)

    diff1 = abs(y - x);
    diff2 = abs(xr - x);
    top = sum(diff1 .* diff1);
    bot = sum(diff2 .* diff2);
    
    SNRimp = 10 * log10(top/bot);

end
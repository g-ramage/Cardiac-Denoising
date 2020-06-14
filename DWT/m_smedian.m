% DWT with modified s-median threshold
% Y   = noisy signal
% wav = wavelet (e.g. 'db8')
% L   = decomposition level
% b   = tuning parameter
function Xr = m_smedian(Y, wav, L, b)

    [c,l] = wavedec(Y, L, wav);
    A = c(1:l(1));
    sigma = wnoisest(c,l,1:L);
    n = size(Y,2);
    D1 = [];
    for k = 1:L
        
        d = detcoef(c,l,k);
        S = 2 ^ (L - (k/L));
        Th = (L/k) * (sigma(k) * sqrt(2 * log(n)))/(S + b);
        d1 = wthresh(d, 's', Th);
        D1 = [d1 D1];
        
    end
    C = [A D1];
    Xr = waverec(C, l, wav);

end
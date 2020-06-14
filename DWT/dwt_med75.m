% Median75 Threshold
% Y    = noisy input
% wav  = wavelet (e.g. 'coif5')
% type = mid-threshold type ('linear'/'non-linear')
% Xr   = denoised output
function Xr = dwt_med75(Y, wav, type)

    G = 1/max(Y);
    Y = G*Y;

    [C,L] = wavedec(Y, 5, wav);

    [D1, D2, D3, D4, D5] = detcoef(C,L,[1 2 3 4 5]);
    A = appcoef(C,L,wav);

    % D4,5 thresholding
    alpha = 1;

    m75_4 = prctile(abs(D4), 75);
    mu_4 = mean(abs(D4));
    sigma2_4 = var(abs(D4));
    if m75_4 < sigma2_4
        Thr_4 = m75_4 * (1-(sigma2_4 - m75_4));
    elseif (m75_4 > sigma2_4) && (m75_4 < mu_4)
        Thr_4 = m75_4;
    elseif m75_4 > mu_4
        Thr_4 = m75_4 + (m75_4 - mu_4);
    end
    if m75_4 <= sigma2_4
        beta = 1.3;
    else 
        beta = 1.4;
    end
    n4 = wnoisest(C,L,4);
    Thr_4 = Thr_4 * n4;
    D4 = mid_thresh(D4, Thr_4, alpha, beta, type);

    m75_5 = prctile(abs(D5), 75);
    mu_5 = mean(abs(D5));
    sigma2_5 = var(abs(D5));
    if m75_5 < sigma2_5
        Thr_5 = m75_5 * (1-(sigma2_5 - m75_5));
    elseif (m75_5 > sigma2_5) && (m75_5 < mu_5)
        Thr_5 = m75_5;
    elseif m75_5 > mu_5
        Thr_5 = m75_5 + (m75_5 - mu_5);
    end
    if m75_5 <= sigma2_5
        beta = 1.3;
    else 
        beta = 1.4;
    end
    n5 = wnoisest(C,L,5);
    Thr_5 = Thr_5 * n5;
    D5 = mid_thresh(D5, Thr_5, alpha, beta, type);

    D1 = zeros(1, size(D1,2));
    D2 = zeros(1, size(D2,2));
    D3 = zeros(1, size(D3,2));
    A = zeros(1, size(A, 2));

    % reconstruction
    F = [A, D5, D4, D3, D2, D1];
    Xr = waverec(F, L, wav);
    Xr = Xr/G;
    Y = Y/G;
    G2 = max(Y) / max(Xr);
    Xr = Xr * G2;

end
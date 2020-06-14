% Modified Median75 Threshold
% Y    = noisy input
% wav  = wavelet (e.g. 'coif5')
% M    = decomposition level (e.g. 5)
% type = mid-threshold type ('linear'/'non-linear')
% Xr   = denoised output
% Dt   = Denoised wavelet coefficients (for analysis purposes)
function [Xr, Dt] = m_dwt_med75(Y, wav, M, type)

    G = 1/max(Y);
    Y = G*Y;

    %decomposition
    [C,L] = wavedec(Y, M, wav);
    
    alpha = 1;

    % threshold detail coefficients
    Dt = [];
    for l = 1:M
        D = detcoef(C, L, l);
        m75 = prctile(abs(D), 75);
        mu = mean(abs(D));
        sigma2 = var(abs(D));
        if m75 < sigma2
            Thr = m75 * (1-(sigma2 - m75));
        elseif (m75 > sigma2) && (m75 < mu)
            Thr = m75;
        elseif m75 > mu
            Thr = m75 + (m75 - mu);
        end
        if m75 <= sigma2
            beta = 1.3;
        else
            beta = 1.4;
        end
        sigma_n = wnoisest(C,L,l);
        Thr = Thr*sigma_n;
        D = mid_thresh(D, Thr, alpha, beta, type);
        Dt = [D Dt];
    end

    % threshold approximation coefficients
    A = appcoef(C,L,wav);
    m75 = prctile(abs(A), 75);
    mu = mean(abs(A));
    sigma2 = var(abs(A));
    if m75 < sigma2
        Thr = m75 * (1-(sigma2 - m75));
    elseif (m75 > sigma2) && (m75 < mu)
        Thr = m75;
    elseif m75 > mu
        Thr = m75 + (m75 - mu);
    end
    if m75 <= sigma2
        beta = 1.3;
    else
        beta = 1.4;
    end
    At = mid_thresh(A, Thr, alpha, beta, type);
    
    % reconstruction
    Dt = [At Dt];
    Xr = waverec(Dt, L, wav);
    
    % correct mean
    my = mean(Y,2);
    Xr = Xr + my;
    
    Xr = Xr/G;

end

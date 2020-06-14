% Adaptive Fourier Decomposition Denoising
% Xr   = denoised signal
% Y    = noisy signal
% fs   = sampling frequency
% SNRe = estimated SNR
% tol  = tolerance (10)
function Xr = AFD_denoise(Y, W, SNRe, tol)

    % pre-processing steps
    
    % Make zero mean:
    N = size(Y,2);
    Yin = Y - mean(Y);
    
    % window definition
    w = hamming(2*W);
    w = w';
    z = zeros(1,W);
    Yin = [z Yin z];

    K = ceil(N/W) + 1; % number of divisions

    % segment + window
    Yk = zeros(K,2*W);
    for k = 1:K
        s = (k-1)*(W);
        Yk(k,:) = w.*Yin(s+1:s+(2*W));    
    end

    % perform AFD denoising
    Xk = zeros(K,2*W);
    for k = 1:K
       
        Xin = Yk(k,:);
        % Form input to AFD
        G = hilbert(Xin);
        
        Xk(k,:) = AFD(Xin, G, 50, SNRe, tol);
        
    end
    
    % reconstruct signal
    X_out = zeros(K, N+2*W);
    for k = 1:K
        s = (k-1)*W; 
        r = (N+2*W) - (s+2*W);
        z1 = zeros(1,s);
        z2 = zeros(1,r);
        X_out(k,:) = [z1 Xk(k,:) z2];
    end

    Xr = sum(X_out, 1);
    Xr = Xr(W+1:N+W);
    
    % fix mean + median filter
    Xr = Xr + mean(Y);
    Xr = medfilt1(Xr);

end
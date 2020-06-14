% vmd_nlm_dwt
% Xr = denoised signal
% Y  = noisy signal
function Xr = vmd_nlm_dwt(Y)

    N = size(Y,2);
    
    % VMD decomposition
    alpha = 200;
    tau = 1; 
    K = 9;
    DC = false; 
    init = 0; 
    tol = 1e-6; 

    [U, ~, ~] = VMD(Y, alpha, tau, K, DC, init, tol);
    
    LF_cuf_off = 5;
    n_HF = K - LF_cuf_off;
    
    % apply DWT to High Frequency Modes
    HF_mode = U((LF_cuf_off+1):9,:);
    HF_clean = zeros(n_HF, N);

    L = 2;
    THR = 'UniversalThreshold';
    wav = 'sym9';

    for i = 1:n_HF

        y = HF_mode(i,:);
        HF_clean(i,:) = wdenoise(y, L,'Wavelet', wav, 'DenoisingMethod',THR);

    end
    
    % apply NLM to Low Frequency Modes
    LF_mode = U(1:LF_cuf_off, :);
    LF_clean = zeros(LF_cuf_off, N);

    R = 10;
    W = 50;
    tau = 10;

    for i = 1:LF_cuf_off

        y = LF_mode(i,:);
        LF_clean(i,:) = m_nlm(y, R, W, tau, 'Euclidean');

    end
    
    % Reconstuct signal by summing denoising HF- and LF-modes
    U_out = zeros(K, N);
    U_out(1:LF_cuf_off,:) = LF_clean;
    U_out((LF_cuf_off+1):9,:) = HF_clean;

    Xr = zeros(1,N);

    for i = 1:K
       Xr = Xr + U_out(i,:);
    end
end
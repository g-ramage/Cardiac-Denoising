% EMD-NLM denoising
% Xr   = denoised signal
% Y    = noisy signal
% R    = patch width (10)
% W    = search neighbourhood (500)
% fs   = sampling frequency (360)
% b    = tuning parameter (21)
function Xr = m_emd_nlm(Y, R, W, fs, b)
    
    med = median(Y,2);
    md = abs(Y - med);
    sigma = median(md)/0.6745;
    tau = sigma * 0.5;

    % step 1: NLM pre-processing
    Y1 = m_nlm(Y, R, W, tau, 'Euclidean');

    % step 2: EMD
    C = emd(Y1);
    C_out = IHP(C, fs, b);

    Xr = sum(C_out, 2);
    Xr = Xr';
    
    my = mean(Y,2);
    Xr = Xr + my;

end






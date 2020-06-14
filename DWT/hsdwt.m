% HEART SOUNDS WAVELET
% DWT with heart sounds wavelet
% Y   = noisy signal
% L   = decomposition level
% THR = thresholding method
function Xr = hsdwt(Y, L, THR)

    % add HS wavelet to wavelet manager
    % include only on first run
    %wavemngr('add', 'HS','hs',2,'10','hswavf');
    
    Xr = wdenoise(Y, L,'Wavelet', 'hs10', 'DenoisingMethod',THR);
    
end
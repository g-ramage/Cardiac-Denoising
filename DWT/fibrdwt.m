% DWT with fibr wavelet
% Y   = noisy signal
% L   = decomposition level
% THR = thresholding method
function Xr = fibrdwt(Y, L, THR)

    % add 'fibr' wavelet to wavelet manager
    % include on first run only
    %wavemngr('add', 'Fibr','fibr',1,'8','fibrwavf');
    
    Xr = wdenoise(Y, L,'Wavelet', 'fibr8', 'DenoisingMethod',THR);
    
end

% EMD-DWT denoising
% Xr  = denoised signal
% Y   = noisy signal
% L   = DWT decomposition level
% wav = DWT wavelet
% THR = DWT thresholding type
function Xr = emd_dwt(Y, L, wav, THR)

    C = emd(Y);
    N = size(C,1);
    K = size(C,2);
    D = zeros(K-1, N);
    for i = 1:K-1
       D(i,:) =  wdenoise(C(:,i), L,'Wavelet', wav, 'DenoisingMethod',THR);
    end
    
    Xr = sum(D,1);
    
    % correct mean
    my = mean(Y,2);
    Xr = Xr + my;
    
end
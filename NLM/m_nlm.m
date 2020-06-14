% non local means denoising
% Xr   = denoised signal
% Y    = noisy signal
% R    = patch width
% W    = search neighbourhood
% tau  = bandwidth parameter
% type = 'Euclidean'/'Modified'
function Xr = m_nlm(Y, R, W, tau, type)

    N = size(Y,2);
    Xr = zeros(1, N);
    % u varies across the whole signal
    for u = 1:N

        S = (u-W):(u+W);

        wsum = 0;
        sum = 0;

        for i = 1:(2*W +1)

            v = wrap_samples(S(i), N);
            
            w = m_nlm_weight(u, v, Y, R, tau, type);

            wsum = wsum + w;
            sum = sum + (Y(v) * w);

        end

        if wsum == 0
            Xr(u) = 0;
        else
            Xr(u) = (1/(wsum)) * sum;
        end

    end
    
end
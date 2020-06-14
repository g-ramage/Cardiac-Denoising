% Mid Thresholding
% D_out = thresholded values
% D     = input values
% T     = threshold
% alpha = lower threshold parameter
% beta  = upper threshold parameter
% type  = 'linear'/'non-linear'
function D_out = mid_thresh(D, T, alpha, beta, type)

    K = size(D,2);
    T = abs(T);
    T1 = alpha*T;
    T2 = beta*T;
    D_out = zeros(1,K);
    
    for k = 1:K
        Dk = abs(D(k));
        if (Dk >= T1) && (Dk <= T2)
            switch type
                case 'linear'
                    Dk = sign(D(k))*(Dk - T1);
                case 'non-linear'
                    Dk = (D(k)^3)/(T2^2);
                otherwise
                    fprintf('Type must be either linear or non-linear');
                    return;
            end
        elseif Dk > T2
            Dk = D(k);
        elseif Dk < T1
            Dk = 0;
        end
        D_out(k) = Dk;
    end

end
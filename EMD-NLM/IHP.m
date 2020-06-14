% IHP thresholding of IMFs
% C_out = thresholded IMFs
% C     = noisy IMFs
% fs    = sampling frequency (360)
% b     = tuning parameter (21)
function C_out = IHP(C,fs,b)

    thr = b/(2*fs);

    L = size(C,2);
    N = size(C,1);
    
    C_out = zeros(N,L);
    
    for l = 1:L
        c = C(:,l);

        Z = [];

        for n = 1:N-1
           sign1 = sign(c(n)); 
           sign2 = sign(c(n+1));
           if sign1 ~= sign2
               Z = [Z n];
           end
        end
        
        % append final sample value
        Z = [Z N];
        
        med = median(c,1);
        md = abs(c - med);
        sigma = median(md)/0.6745;
        tau = sigma * sqrt(2 * log10(N));

        K = size(Z,2);
        zp = 1;
        for k = 1:K
            I = (Z(k)-zp+1)/fs;
            if I >= thr
                C_out(zp:Z(k),l) = c(zp:Z(k));
            else
                C_out(zp:Z(k),l) = wthresh(c(zp:Z(k)), 's', tau);
            end
            zp = Z(k);
        end
        
    end
    
end
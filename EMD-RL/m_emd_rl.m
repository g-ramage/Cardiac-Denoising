% EMD-RL Denoising
% Y      = noisy signal
% alpha  = RL order (must be <1) (e.g. 0.5)
% W      = length of RL filter (e.g. 5)
% SG_ord = order of Savitzky-Golay filter (e.g 3)
% Xr     = denoised signal
function [Xr, final] = m_emd_rl(Y, alpha, W, SG_ord)

    C = emd(Y);
    K = size(C,2) - 1; % no. IMFs
    N = size(C,1);
    
    % remove residue
    C = C(:,1:K)'; 

    % BW selection
    n_count = K-3;
    n = n_count;
    for k = K:-1:n_count
        [~,pk] = spow(C(k,:));
        [~,pk1] = spow(C(k-1,:));
        if pk > pk1 %no BW present
           n = k; 
           break;
        end
    end

    % SG filtering
    SG = zeros((K-n), N);
    for i = K:-1:n
       SFk = 1; 
       SG_length = 2501 - (750*(K-i));
       SG(i-n+1, :) = SFk * sgolayfilt(C(i,:), SG_ord, SG_length);
    end
    
    % Select HF-noise IMFs
    bw = zeros(K, 1);
    for i = 1:K
       bw(i) = obw(C(i,:));
    end
    idx = 1:K;
    x = idx(n:K)';
    y = bw(n:K);
    [a,b] = lreg(x,y);
    sigma_bw = std(bw);
    n_noisy = 1;
    for i = 2:(n-1)
        xi = i;
        yi = a*xi + b;
        dist = norm([bw(i), i] - [yi, xi]);
        if dist < sigma_bw
            n_noisy = i - 1;
            break;
        end
    end
    
    clean_IMFs = C((n_noisy + 1):(n-1),:);

    % RL filtering
    RLF = zeros(n_noisy, N);
    for i = 1:n_noisy
       rlfilt = RL(alpha, W, C(i,:));
       mdfilt = medfilt1(rlfilt, 6);
       RLF(i,:) = mdfilt(3:N+2);
    end
    

    final = ([RLF', clean_IMFs', SG'])';
    Xr = sum(RLF, 1) + sum(clean_IMFs,1) + sum(SG,1);
    
    % correct mean
    my = mean(Y,2);
    Xr = Xr + my;

end

% HEART SOUNDS WAVELET
% wname = 'hs10'
function [RF, DF] = hswavf(wname)

    N = str2double(wname(3:end));
    
    switch N
        case 10
            RF = [0.0269 -0.0323 -0.2411 0.0541 0.8995 0.8995 0.0541 -0.2411 -0.0323 0.0269];
            DF = [0.0198 0.0238 -0.0233 0.1456 0.5411 0.5411 0.1456 -0.0233 0.0238 0.0198];
        otherwise
            fprintf('Order: %d not supported\m',num);
    end

end
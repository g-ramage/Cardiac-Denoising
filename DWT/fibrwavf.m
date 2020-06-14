% Fibr Wavelet Definition
% wname = 'fibr8'
function F = fibrwavf(wname)

    N = str2double(wname(5:end));
    
    switch N
        case 8
            F = [0.001590 -0.056193 0.056736 0.493436 0.493436 0.056736 -0.056193 0.001590];
        otherwise
            fprintf('Order: %d not supported\m',num);
    end

end
% function to calculate MSE
% x[n]  = original signal
% xr[n] = reconstructed signal
function MSEout = MSE(x, xr)

    diff = x - xr;
    top = sum(diff .* diff);
    N = size(x,2);
    MSEout = top / N;

end
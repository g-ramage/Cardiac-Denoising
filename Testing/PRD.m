% function to calculate PRD
% x[n]  = original signal
% xr[n] = reconstructed signal
function PRDout = PRD(x, xr)

    diff = x - xr;
    top = sum(diff .* diff);
    bot = sum(x .* x);
    
    PRDout = 100 * sqrt(top/bot);

end
% Wrap index i to N samples
% i = index
% N = no. samples
function s = wrap_samples(i, N)

    if i < 1 
        % negative index, wrap to top
        s = N + i;
    elseif i > N
        % positive index, wrap to bottom
        s = i - N;
    else
        s = i;
    end

end
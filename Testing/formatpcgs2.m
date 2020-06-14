% Create array of test signals
function PCGs = formatpcgs2()

    L = 100;
    N = 22050;
    PCGs = zeros(L, N);
    pfx = "Test_Signal_";
    for l = 1:L
        sfx = int2str(l);
        fname = pfx + sfx + ".wav";
        [X, ~] = audioread(fname);
        X = downsample(X,20)';
        X = X(1:N);
        PCGs(l,:) = X;
    end

end
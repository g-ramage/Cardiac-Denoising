% Create array of test signals
function PCGs = formatpcgs()

    L = 50;
    PCGs = zeros(L, 20000);
    pfx = "a00";
    for l = 1:9
        sfx = "0" + int2str(l);
        fname = pfx + sfx + "m.mat";
        load(fname);
        PCGs(l,:) = val;
    end
    for l = 10:50
        sfx = int2str(l);
        fname = pfx + sfx + "m.mat";
        load(fname);
        PCGs(l,:) = val;
    end

end
% Create array of test signals
function ECGs = formatsigs()

    ECGs = zeros(3600, 46);
    load('100m.mat');
    ECGs(:, 1) = val;
    load('101m.mat');
    ECGs(:, 2) = val;
    load('103m.mat');
    ECGs(:, 3) = val;
    load('105m.mat');
    ECGs(:, 4) = val;
    load('106m.mat');
    ECGs(:, 5) = val;
    load('107m.mat');
    ECGs(:, 6) = val;
    load('108m.mat');
    ECGs(:, 7) = val;
    load('109m.mat');
    ECGs(:, 8) = val;
    load('111m.mat');
    ECGs(:, 9) = val;
    load('112m.mat');
    ECGs(:, 10) = val;
    
    load('113m.mat');
    ECGs(:, 11) = val;
    load('114m.mat');
    ECGs(:, 12) = val;
    load('115m.mat');
    ECGs(:, 13) = val;
    load('116m.mat');
    ECGs(:, 14) = val;
    load('117m.mat');
    ECGs(:, 15) = val;
    load('118m.mat');
    ECGs(:, 16) = val;
    load('119m.mat');
    ECGs(:, 17) = val;
    load('121m.mat');
    ECGs(:, 18) = val;
    load('122m.mat');
    ECGs(:, 19) = val;
    load('123m.mat');
    ECGs(:, 20) = val;
    
    load('124m.mat');
    ECGs(:, 21) = val;
    load('200m.mat');
    ECGs(:, 22) = val;
    load('201m.mat');
    ECGs(:, 23) = val;
    load('202m.mat');
    ECGs(:, 24) = val;
    load('203m.mat');
    ECGs(:, 25) = val;
    load('205m.mat');
    ECGs(:, 26) = val;
    load('207m.mat');
    ECGs(:, 27) = val;
    load('208m.mat');
    ECGs(:, 28) = val;
    load('209m.mat');
    ECGs(:, 29) = val;
    load('210m.mat');
    ECGs(:, 30) = val;
    
    load('212m.mat');
    ECGs(:, 31) = val;
    load('213m.mat');
    ECGs(:, 32) = val;
    load('214m.mat');
    ECGs(:, 33) = val;
    load('215m.mat');
    ECGs(:, 34) = val;
    load('217m.mat');
    ECGs(:, 35) = val;
    load('219m.mat');
    ECGs(:, 36) = val;
    load('220m.mat');
    ECGs(:, 37) = val;
    load('221m.mat');
    ECGs(:, 38) = val;
    load('222m.mat');
    ECGs(:, 39) = val;
    load('223m.mat');
    ECGs(:, 40) = val;
    
    load('228m.mat');
    ECGs(:, 41) = val;
    load('230m.mat');
    ECGs(:, 42) = val;
    load('231m.mat');
    ECGs(:, 43) = val;
    load('232m.mat');
    ECGs(:, 44) = val;
    load('233m.mat');
    ECGs(:, 45) = val;
    load('234m.mat');
    ECGs(:, 46) = val;
    
    ECGs = ECGs';
    
end

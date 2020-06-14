% ECG DENOISING TESTING FRAMEWORK
clear all;

TEST_METHODS = ["DWT","FIBRDWT","HS_DWT","SMEDIAN","MSMEDAIN","NLM","MNLM","VMD","EMD_NLM","EMD_DWT","EMD_RL","AFD"];
T = size(TEST_METHODS,2);

% total 46 records
R = 1;
G = 200;
N = 3600;
fs = 360;
ECGs = formatsigs();

load('mam.mat');
MA = val(1,:);
load('bwm.mat');
BW = val(1,:);

for tst = 1:T
    METHOD = TEST_METHODS(tst);
    for a = 1:2
        N_ECGs = zeros(R, N);
        C_ECGs = zeros(R, N);

        Ev_SNRi = zeros(1, R);
        Ev_MSE  = zeros(1, R);
        Ev_PRD  = zeros(1, R);
        switch a
            case 1
                noise = BW;
                NOISE = "BW";
            case 2 
                noise = MA;
                NOISE = "MA";
        end
        for r = 1:R
            X = ECGs(r, :);

            % add noise
            Y = X + noise; % real BW noise

            % array of noisy ECGs
            N_ECGs(r, :) = Y;

            diff1 = abs(Y - X);
            snr_in = 10*log10(sum(diff1 .* diff1));

            % denoise with given test function
            switch METHOD
                case "DWT"
                    Xr = wdenoise(Y, 6,'Wavelet', 'db8', 'DenoisingMethod','SURE');
                case "FIBRDWT"
                    Xr = fibrdwt(Y, 6, 'SURE');
                case "HSDWT"
                    Xr = hsdwt(Y, 5, 'SURE');
                case "SMEDIAN"
                    Xr = smedian(Y, 'sym10',3,1);
                case "MSMEDIAN"
                    Xr = m_smedian(Y,'sym10',3,1);
                case "NLM"
                    Xr = m_nlm(Y, 10, 500, 10, 'Euclidean');
                case "MNLM"
                    Xr = m_nlm(Y, 3, 5, 5, 'Modified');
                case "VMD"
                    Xr = vmd_nlm_dwt(Y);
                case "EMD_NLM"
                    Xr = m_emd_nlm(Y, 10, 500, 360, 21);
                case "EMD_DWT"
                    Xr = emd_dwt(Y, 2, 'db8', 'SURE');
                case "EMD_RL"
                    [Xr,~] = m_emd_rl(Y, 0.5, 5, 3);
                case "AFD"
                    Xr = AFD_denoise(Y, fs/2, snr_in, 10);
            end

            % array of cleaned ECGs
            C_ECGs(r, :) = Xr;

            % remove gain
            Xr = Xr/G;
            Y = Y/G;
            X = X/G;

            % populate metrics
            Ev_SNRi(r) = SNRi(X, Xr, Y);
            Ev_MSE(r)  = MSE(X, Xr);
            Ev_PRD(r)  = PRD(X, Xr);
            
            pc = (r/R) * 100;
            out = METHOD + " " + NOISE + ": complete = " + int2str(pc) + "%% \n";
            fprintf(out);
        end
        % Results consolidation

        % Average
        Av_SNRi = mean(Ev_SNRi);
        Av_MSE  = mean(Ev_MSE);
        Av_PRD  = mean(Ev_PRD);

        % Std deviation
        S_SNRi = std(Ev_SNRi);
        S_MSE = std(Ev_MSE);
        S_PRD = std(Ev_PRD);

        % Best Results
        [B_SNRi, idx] = max(Ev_SNRi);
        B_MSE  = min(Ev_MSE);
        B_PRD  = min(Ev_PRD);

        pfx = "ECG_";
        fname = pfx + NOISE + "_" + METHOD;
        save(fname);
    end
    
    for N_SNR = 5:5:15
        N_ECGs = zeros(R, N);
        C_ECGs = zeros(R, N);

        Ev_SNRi = zeros(1, R);
        Ev_MSE  = zeros(1, R);
        Ev_PRD  = zeros(1, R);
      	for r = 1:R
            X = ECGs(r, :);

            % add noise
            Y = awgn(X, N_SNR, 'measured');

            % array of noisy ECGs
            N_ECGs(r, :) = Y;

            diff1 = abs(Y - X);
            snr_in = 10*log10(sum(diff1 .* diff1));

            % denoise with given test function
            switch METHOD
                case "DWT"
                    Xr = wdenoise(Y, 6,'Wavelet', 'db8', 'DenoisingMethod','SURE');
                case "FIBRDWT"
                    Xr = fibrdwt(Y, 6, 'SURE');
                case "HSDWT"
                    Xr = hsdwt(Y, 5, 'SURE');
                case "SMEDIAN"
                    Xr = smedian(Y, 'sym10',3,1);
                case "MSMEDIAN"
                    Xr = m_smedian(Y,'sym10',3,1);
                case "NLM"
                    Xr = m_nlm(Y, 10, 2000, 10, 'Euclidean');
                case "MNLM"
                    Xr = m_nlm(Y, 3, 5, 5, 'Modified');
                case "VMD"
                    Xr = vmd_nlm_dwt(Y);
                case "EMD_NLM"
                    Xr = m_emd_nlm(Y, 10, 500, 360, 21);
                case "EMD_DWT"
                    Xr = emd_dwt(Y, 2, 'db8', 'SURE');
                case "EMD_RL"
                    [Xr,~] = m_emd_rl(Y, 0.5, 5, 3);
                case "AFD"
                    Xr = AFD_denoise(Y, fs/2, snr_in);
            end

            % array of cleaned ECGs
            C_ECGs(r, :) = Xr;

            % remove gain
            Xr = Xr/G;
            Y = Y/G;
            X = X/G;

            % populate metrics
            Ev_SNRi(r) = SNRi(X, Xr, Y);
            Ev_MSE(r)  = MSE(X, Xr);
            Ev_PRD(r)  = PRD(X, Xr);
            
            pc = (r/R) * 100;
            out = METHOD + " AWGN" + int2str(N_SNR) + ": complete = " + int2str(pc) + "%% \n";
            fprintf(out);
        end
        % Results consolidation

        % Average
        Av_SNRi = mean(Ev_SNRi);
        Av_MSE  = mean(Ev_MSE);
        Av_PRD  = mean(Ev_PRD);

        % Std deviation
        S_SNRi = std(Ev_SNRi);
        S_MSE = std(Ev_MSE);
        S_PRD = std(Ev_PRD);

        % Best Results
        [B_SNRi, idx] = max(Ev_SNRi);
        B_MSE  = min(Ev_MSE);
        B_PRD  = min(Ev_PRD);

        pfx = "ECG_AWGN";
        fname = pfx + int2str(N_SNR) + "_" + METHOD;
        save(fname);
    end
end





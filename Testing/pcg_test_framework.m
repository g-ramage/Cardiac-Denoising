% PCG DENOISING TEST FRAMEWORK
clear all;
TEST_METHODS = ["DWT", "FIBRDWT", "HSDWT", "SMEDIAN", "MSMEDIAN", "NLM", "MNLM", "EMD_NLM", "EMD_DWT", "EMD_RL", "M75", "M_M75","AFD"];
T = size(TEST_METHODS,2);

% total 50 records
R = 50;
G = 1000;
N = 20000;
fs = 2000;
PCGs = formatpcgs();

%%
for tst = 1:T
    METHOD = TEST_METHODS(tst);
    for N_SNR = 5:5:15

        N_PCGs = zeros(R, N);
        C_PCGs = zeros(R, N);

        Ev_SNRi = zeros(1, R);
        Ev_MSE  = zeros(1, R);
        Ev_PRD  = zeros(1, R);

        for r = 1:R

            X = PCGs(r, :);

            % add noise
            Y = awgn(X, N_SNR, 'measured');

            % array of noisy ECGs
            N_PCGs(r, :) = Y;

            diff1 = abs(Y - X);
            snr_in = 10*log10(sum(diff1 .* diff1));

            switch METHOD
                case "DWT"
                    Xr = wdenoise(Y, 8,'Wavelet', 'coif5', 'DenoisingMethod','SURE');
                case "FIBRDWT"
                    Xr = fibrdwt(Y, 8, 'SURE');
                case "HSDWT"
                    Xr = hsdwt(Y, 8, 'SURE');
                case "SMEDIAN"
                    Xr = smedian(Y,'coif5',3,1);
                case "MSMEDIAN"
                    Xr = m_smedian(Y,'coif5',3,1);
                case "NLM"
                    Xr = nlm(Y, 5, 10, 5);
                case "MNLM"
                    Xr = m_nlm(Y, 5, 10, 5, 'Modified');
                case "VMD" 
                    Xr = vmd_nlm_dwt(Y);
                case "EMD_NLM"
                    Xr = emd_nlm(Y, fs, 1);
                case "EMD_DWT"
                    Xr = emd_dwt(Y, 2, 'db8', 'SURE');
                case "EMD_RL"
                    [Xr,~] = m_emd_rl(Y, 0.5, 5, 3);
                case "M75"
                    Xr = dwt_med75(Y, 'coif5', 'non-linear');
                case "M_M75"
                    [Xr, ~] = m_dwt_med75(Y, 'coif5', 5, 'non-linear');
                case "AFD"
                    Xr = AFD_denoise(Y, 250, snr_in, 10);
            end

            % array of cleaned ECGs
            C_PCGs(r, :) = Xr;

            % remove gain
            Xr = Xr/G;
            Y = Y/G;
            X = X/G;

            % populate metrics
            Ev_SNRi(r) = SNRi(X, Xr, Y);
            Ev_MSE(r)  = MSE(X, Xr);
            Ev_PRD(r)  = PRD(X, Xr);
            pc = (r/R) * 100;
            out = METHOD + ": SNR = " + int2str(N_SNR) + ", complete = " + int2str(pc) + "%% \n";
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

        [B_SNRi, idx] = max(Ev_SNRi);
        B_MSE  = min(Ev_MSE);
        B_PRD  = min(Ev_PRD);

        % variable save
        pfx = "PCG_AWGN";
        sfx = "_" + METHOD;
        fname = pfx + int2str(N_SNR) + sfx;
        save(fname);
        
    end
end



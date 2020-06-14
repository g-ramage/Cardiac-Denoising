% PCG TEST SIGNAL DENOISING FRAMEWORK

clear all
TEST_METHODS = ["DWT","FIBR_DWT","HS_DWT","SMEDIAN","MSMEDAIN","NLM","MNLM","VMD","EMD_DWT","EMD_NLM","EMD_RL","M75","M_M75","AFD"];
T = size(TEST_METHODS,2);
PCGs = formatpcgs2();
% total 100 records
R = 100;
G = 1;
N = 22050;
fs = 2205;

%%
for tst = 1:T
    METHOD = TEST_METHODS(tst);

        N_PCGs = zeros(R, N);
        C_PCGs = zeros(R, N);

        Ev_MSE  = zeros(1, R);
        Ev_PRD  = zeros(1, R);

        %
        for r = 1:R

            X = PCGs(r, :);

            % add noise
            Y = X;

            % array of noisy ECGs
            N_PCGs(r, :) = Y;

            switch METHOD
                case "DWT"
                    Xr = wdenoise(Y, 8,'Wavelet', 'coif5', 'DenoisingMethod','UniversalThreshold');
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
                    Xr = AFD_denoise(Y, 350, 50, 10);
            end

            % array of cleaned ECGs
            C_PCGs(r, :) = Xr;

            % remove gain
            Xr = Xr/G;
            Y = Y/G;
            X = X/G;

            % populate metrics
            %Ev_SNRi(r) = SNRi(X, Xr, Y);
            Ev_MSE(r)  = MSE(X, Xr);
            Ev_PRD(r)  = PRD(X, Xr);
            out = METHOD + ": complete = " + int2str(r) + "%% \n";
            fprintf(out);

        end

        % Results consolidation

        % Average
        %Av_SNRi = mean(Ev_SNRi);
        Av_MSE  = mean(Ev_MSE);
        Av_PRD  = mean(Ev_PRD);

        % Std deviation
        %S_SNRi = std(Ev_SNRi);
        S_MSE = std(Ev_MSE);
        S_PRD = std(Ev_PRD);

        %[B_SNRi, idx] = max(Ev_SNRi);
        B_MSE  = min(Ev_MSE);
        B_PRD  = min(Ev_PRD);

        % variable save
        fname = "PCG_TEST_" + METHOD;
        save(fname);
end



% Adaptive Fourier Decomposition
% Xr       = denoised signal
% Y        = noisy signal
% G        = AFD input
% max_iter = max decomposition level
% SNRe     = estimated SNR
% tol      = tolerance (10)
function Xr = AFD(Y, G, max_iter, SNRe, tol)

    N = size(Y,2);
    % AFD algorithm
    exit = 500;
    alpha = 1;
    beta = 0.5;
    gamma = 2;

    G_n = zeros(max_iter, N);
    a_n = zeros(max_iter, 1);
    e_n = zeros(max_iter, N);
    B_n = zeros(max_iter, N);

    G_n(1, :) = G;
    a_n(1) = 0;
    e_n(1,:) = ones(1,N);
    B_n(1,:) = ones(1,N);

    E_n = 0.5*(abs((AFD_fun(G_n(1,:), e_n(1,:))))^2);
    OFV_n = calc_OFV(Y, E_n, SNRe);


     for n = 1:(max_iter-1)
       c_n = cn(a_n(n), N);
       d_n = dn(a_n(n), N);

       % calculate G_(N+1)
       G_n(n+1,:) = (G_n(n,:) - (AFD_fun(G_n(n,:), e_n(n,:)))*e_n(n,:)) .* c_n;

       % find a_(N+1)
       a_n(n+1) = nm(G_n(n+1,:), exit, alpha, beta, gamma);

       % calculate e_(N+1)
       e_n(n+1,:) = ev_an(a_n(n+1), N);

       % calculate B_(N+1)
       B_n(n+1,:) = e_n(n+1,:) .* d_n .* B_n(n,:);

       % calculate energy E_n
       E_n = E_n + 0.5*(abs(AFD_fun(G_n(n+1,:), e_n(n+1,:))^2));

       % calculate OFV
       OFV_n1 = calc_OFV(Y, E_n, SNRe);
       diff = abs(OFV_n1 - OFV_n);

       if diff < tol
            break;
       end

       OFV_n = OFV_n1;

     end
     
    Xrc = zeros(1,N);
    for k = 1:20

        h = AFD_fun(G_n(k,:), e_n(k,:)) * B_n(k,:);
        Xrc = Xrc + h;

    end

    Xr = real(Xrc);

end

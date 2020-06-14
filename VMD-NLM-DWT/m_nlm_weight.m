% non local means weight function
% w  = output
% u  = sample u
% v  = sample v
% y  = noisy signal
% R  = patch width
% tau = bandwidth parameter
% type = 'Euclidean'/'Modified'
function w = m_nlm_weight(u, v, y, R, tau, type)

    N = size(y,2);
    Pu = zeros(1,2*R+1);
    Pv = zeros(1,2*R+1);

    h = ((2 * R) + 1) * (tau);

    for r = (-R):R
        k = r + R + 1;
        Pu(k) = y(wrap_samples((u + r), N));
        Pv(k) = y(wrap_samples((v + r), N));
    end

    switch type
        case 'Euclidean'
            d = norm(Pu - Pv)^2;
            bot = 2 * (2*R + 1) * (tau^2);
            w = exp(- d / bot);
        case 'Modified'
            theta = acos(dot(Pu, Pv)/(norm(Pu)*norm(Pv)));
            gamma = sin(2*theta)/(1 + cos(2*theta));
            dtop = norm(gamma*Pu - Pv);
            dbot = 1 + gamma^2;
            d = sqrt(dtop)/sqrt(dbot);

            if(d <= h)
                w = (1 - d/((((2 * R) + 1)*(tau^2))))^8;
            else
                w = 0;
            end
        otherwise
            fprintf('type either Euclidean or Modified');
   end

end
% Nelder Mead Optimisation for AFD
% G     = G_n
% stop  = max iterations
% alpha = reflection constant
% beta  = contraction constant
% gamma = expansion constant
function z_best = nm(G, stop, alpha, beta, gamma)

    p = [(2*pi/3),(4*pi/3),(2*pi)];
    r = [0.3 0.3 0.3];
    z = r .* exp(1i .* p);
    
    F = zeros(1,3);
    for k = 1:3
       F(k) = f(G, z(k));
    end
    
    for k = 1:stop
    
        [F, z] = re_sort(F,z);

        m = centroid(z);
        
        zr = nm_reflect(alpha, z);
        FR = f(G, zr);
        
        ze = nm_expand(gamma, [zr, z(2), z(3)]);
        FE = f(G, ze);
        
        zc1 = nm_contract(beta, [z(3), z(1), z(2)]);
        FC1 = f(G, zc1);
        
        zc2 = nm_contract(beta, [zr, z(2), z(1)]);
        FC2 = f(G, zc2);
        
        zs = (z(1) + z(3))/2;
        FS = f(G, zs);
        
        if FR > F(3)
            if FE > FR
                z(3) = ze;
                F(3) = FE;
            else
                z(3) = zr;
                F(3) = FR;
            end
        elseif (FC1 > F(3)) || (FC2 > F(3))
            if FC1 > FC2
                z(3) = zc1;
                F(3) = FC1;
            else
                z(3) = zc2;
                F(3) = FC2;
            end
        else
            z(3) = zs;
            F(3) = FS;
            z(2) = m;
            F(2) = f(G, m);
        end
    
    end
    
    z_best = z(1);
    
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Numerical shortcut for inverse of mixture of two normal distribution
% Alexandre Beaulne Oct. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = mixnorminv(y, mu1, sigma1, mu2, sigma2, p)

    if(size(y,1)<size(y,2))
        y = y';
    end

    n = 10000000;
    u = rand(n,1);
    v = rand(n,1);

    % Box-Muller algorithm
    N1 = sqrt(-2*log(rand(n,1))).*cos(2*pi*rand(n,1));
    N2 = sqrt(-2*log(rand(n,1))).*sin(2*pi*rand(n,1));

    N1 = sigma1*N1+mu1;
    N2 = sigma2*N2+mu2;

    uniform = rand(n,1);

    gaussMixture = [uniform<p].*N1+[uniform>=p].*N2;
    [codomain,domain] = hist(gaussMixture,2000);
    codomain = codomain/n;
    F = cumsum(codomain);

    clear n u v N1 N2 uniform gaussMixture codomain
    
    x = domain(length(F)-sum((repmat(y,1,length(F))<repmat(F,length(y),1))'));
end

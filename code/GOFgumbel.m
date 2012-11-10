
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test goodness-of-fit Gumbel copula using Sn test from Bruno
% Remillard's "GOODNESS-OF-FIT TESTS FOR COPULAS OF MULTIVARIATE TIME
% SERIES" paper, p.10.
%
% Alexandre Beaulne, Nov 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p,N] = GOFgumbel(x,N)
  
    U = pseudos(x);
  
    thetahat = 1/est_archi(U,3,1.0e-8);

    Sn = sum((empirical_copula(U)-gumbelcdf(U,thetahat)).^2);
  
    [n,d] = size(U);

    Sn_bootstrap = NaN(N,1);

    for k = 1:N
      
        disp(strcat('Iteration',32,int2str(k),32,'of',32,int2str(N)));

        U = gumbelrnd(thetahat,d,n);

        theta = 1/est_archi(U,3,1.0e-8);
        
        Sn_bootstrap(k) = sum((empirical_copula(U)-gumbelcdf(U,theta)).^2);

    end
  
    p = sum(Sn_bootstrap>Sn)/k;
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test goodness-of-fit Frank copula using Sn test from Bruno
% Remillard's "GOODNESS-OF-FIT TESTS FOR COPULAS OF MULTIVARIATE TIME
% SERIES" paper, p.10.
%
% Alexandre Beaulne, Nov 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p,N] = GOFfrank(z,N)  
  
    U = pseudos(z);
  
    thetahat = -log(est_archi(U,2,1.0e-6));

    Sn = sum((empirical_copula(U)-frankcdf(U,thetahat)).^2);
  
    [n,d] = size(U);

    Sn_bootstrap = NaN(N,1);

    for k = 1:N
      
        disp(strcat('Iteration',32,int2str(k),32,'of',32,int2str(N)));

        U = frankrnd(thetahat,d,n);
    
        theta = -log(est_archi(U,2,1.0e-6));

        Sn_bootstrap(k) = sum((empirical_copula(U)-frankcdf(U,theta)).^2);

    end
  
    p = sum(Sn_bootstrap>Sn)/k;
  
end


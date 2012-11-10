
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test goodness-of-fit Student t copula using Sn test from Bruno
% Remillard's "GOODNESS-OF-FIT TESTS FOR COPULAS OF MULTIVARIATE TIME
% SERIES" paper, p.10.
%
% Alexandre Beaulne, Nov 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = tcopulaGOF(U)

  [rhohat,nuhat] = tcopulafit(U);

  Sn = sum((empirical_copula(U)-copulacdf('t',U,rhohat,nuhat)).^2);

  N = 100;
  
  n = size(U,1);

  Sn_bootstrap = NaN(N,1);

  for k = 1:N

    U = copularnd('t',rhohat,nuhat,n);

    [rhohat_bs, nuhat_bs] = tcopulafit(U);

    Sn_bootstrap(k) = ...
        sum((empirical_copula(U)-copulacdf('t',U,rhohat_bs,nuhat_bs)).^2);

  end
  
  p = sum(Sn_bootstrap>Sn)/k;
  
end


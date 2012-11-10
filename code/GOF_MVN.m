function [p,N] = GOF_MVN(x,N)
%
%   test goodness-of-fit of a multivariate gaussian by parametric
%   bootstrapping, return p value and number of simulations
%

    T = size(x,1);

    mu = mean(x);
    Sigma = cov(x);

    S = sum((mvecdf(x)-MVN_CDF(x,mu,Sigma)).^2)/T;

    Sn = NaN(N,1);

    for i = 1:N
        
        disp(strcat('Bootstrap',32,num2str(i),32,'of',32,num2str(N)));
        
        y = mvnrnd(mu,Sigma,T);
        
        mu_hat = mean(y);
        Sigma_hat = cov(y);
        
        Sn(i) = sum((mvecdf(y)-MVN_CDF(y,mu_hat,Sigma_hat)).^2)/T;

    end

    p = sum(Sn>=S)/N;

end

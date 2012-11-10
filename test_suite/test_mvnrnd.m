
x = randn(1000,3);

mu = mean(x);
Sigma = cov(x);

% Sigma=pos_def(Sigma);

x1 = mvnrnd(mu,Sigma,1000);

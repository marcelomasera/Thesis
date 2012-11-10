
N = 1000;

mu = [-10 0 10];

Sigma = [-1 2 3; 2 3 0; 3 0 4];

Sigma = pos_def(Sigma);

r = mvnrnd(mu,Sigma,N);

y_e = mvecdf(r);

y_g = mvncdf(r,mu,Sigma);

hist(abs(y_e-y_g),50);

ylabel(strcat('freq (out of',32,int2str(N),32,')'));

xlabel('errors');

stairs(sort(y_e));

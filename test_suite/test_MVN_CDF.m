
mu = [-10 0 10];

Sigma = [-1 2 3; 2 3 0; 3 0 4];
Sigma = pos_def(Sigma);

r = mvnrnd(mu,Sigma,1000);

tic
y_mvncdf = mvncdf(r,mu,Sigma);
disp(strcat('mvncdf took',32,num2str(toc),32,'secs'));

tic
y_MVN_CDF = MVN_CDF(r,mu,Sigma,10000);
disp(strcat('MVN_CDF took',32,num2str(toc),32,'secs'));

hist(y_mvncdf-y_MVN_CDF,50);
title('ERRORS');


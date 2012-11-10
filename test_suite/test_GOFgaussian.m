
mu = [0 0 0];

Sigma = [-1 2 3; 2 3 0; 3 0 4];

Sigma = pos_def(Sigma);

x = mvnrnd(mu,Sigma,1000);

p_normal = GOFgaussian(x)

nu = 10;

x = mvtrnd(Sigma,nu,1000);

p_student = GOFgaussian(x)

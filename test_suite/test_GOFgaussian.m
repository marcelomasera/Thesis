
N = 1000;

d = 3;

Temp = rand(3,3);

Sigma = Temp'*Temp;

Rho = corrcov(Sigma);

U = copularnd('Gaussian',Rho,N);

p_normal = GOFgaussian(U,200)

nu = 4;

U = copularnd('t',Rho,nu,N);

p_student = GOFgaussian(U,200)
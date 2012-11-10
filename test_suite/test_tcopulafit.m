
tic

n = 2000;
d = 3;
nu=6;

rho = [1 0.8 0.5;
       0.8 1 -0.3;
       0.5 -0.3 1];
    
rho = pos_def(rho);

U = copularnd('t',rho,nu,n);

[rhohat,nuhat] = tcopulafit(U)

[rho,nu] = copulafit('t',U)

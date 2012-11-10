
rho = pos_def([1 0.2 0.4 0.5; 0.2 1 0.6 0.9; 0.4 0.6 1 0.1; 0.5 0.9 0.1 1]);
nu = 4.5;
U = copularnd('t',rho,nu,2);

%p=tcopulaGOF(U)

profile on
copulacdf('t',U,rho,nu)
profile off
profile viewer

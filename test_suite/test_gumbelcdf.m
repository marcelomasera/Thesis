
U = gumbelrnd(1.5,9,1000);

% Y1 = copulacdf('Gumbel',U,1.5);

Y2 = gumbelcdf(U,1.5);

hist(abs(Y1-Y2),50)

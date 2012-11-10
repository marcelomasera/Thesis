
U=copularnd('Frank',1,1000);

Y1=copulacdf('Frank',U,1);

Y2=frankCDF(U,1);

hist(abs(Y1-Y2),50);

figure;

plot(Y1(1:10),'or');

hold on;

plot(Y2(1:10),'xb');


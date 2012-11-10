
z = trnd(4,10000,9);

hist(z(:,1),50);

U = pseudos(z);

disp(max(max(U)));

disp(min(min(U)));

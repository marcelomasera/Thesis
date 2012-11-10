
% U = copularnd('Frank',3,20000);
U = frankrnd(3,9,499);

z = norminv(U);

size(z)
max(max(z))
min(min(z))
figure;
hist(z,25);   

% theta_hat_matlab = copulafit('Frank',U);
theta_hat_bruno = est_archi(z,2,1.0e-8);

theta_hat_bruno = -log(theta_hat_bruno);

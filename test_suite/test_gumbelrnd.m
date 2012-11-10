
% U = copularnd('Gumbel',2,10000);
U = gumbelrnd(2,2,10000);

maximum = max(max(U))
minimum = min(min(U))

theta_matlab = copulafit('Gumbel',U)
theta_bruno = est_archi(U,3,1.0e-8)

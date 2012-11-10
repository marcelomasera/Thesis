% Gumbel copula's cumulative distribution function
function Y = gumbelcdf(U,theta)

    Y = exp(-((sum((-log(U)).^theta,2)).^(1/theta)));

end

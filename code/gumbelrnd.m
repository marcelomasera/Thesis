% Generates random marginal from
% multi-demensional Gumbel random

function U = gumbelrnd(theta,d,N)
    % from Melchiori 2006

    u = rand(N,d);
    
    alpha = 1/theta;
    beta = 1;
    gamma = cos(pi/(2*theta))^theta;
    delta = 0;
    
    Y = stblrnd(alpha,beta,gamma,delta,N,1);
    
    %s = -log(u)./fastrepmat(Y,1,d);
    s = -log(u)./repmat(Y,1,d);

    U = exp(-s.^(1/theta));

end

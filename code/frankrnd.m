
function X = frankrnd(theta,d,N)
% from Melchiori 2006

    u = rand(N,d);
    
    alpha = 1-exp(-theta);
    
    Y = logrnd(alpha,N);
    
    %s = -log(u)./fastrepmat(Y,1,d);
    s = -log(u)./repmat(Y,1,d);

    X = -log(1-exp(-s)*alpha)/theta;

end

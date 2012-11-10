
% Generate N D-Dim. random vectors from Clayton copula with dependence
% parameter theta, from Melchiori 2006, Algorithm 1
%
% Alexandre Beaulne, Dec. 2011

function U = claytonrnd(theta,N,D)

    % (1)
    u = rand(N,D);

    % (2)
    Y = random('Gamma',1/theta,1,N,1);

    % (3)
    %s = -log(u)./fastrepmat(Y,1,D);
    s = -log(u)./repmat(Y,1,D);

    % (4)
    U = (1+s).^(-1/theta);

end

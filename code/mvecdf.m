
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multivariate empirical cumulative distribution function
% Alexandre Beaulne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = mvecdf(X)

    N = size(X,1);

    Y = NaN(N,1);

    for i = 1:N
        Y(i) = sum(prod(double(X<=repmat(X(i,:),N,1)),2))/N;
    end
end

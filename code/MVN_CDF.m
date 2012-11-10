function Prob = MVN_CDF(X,mu,sigma,ndraws)

% Purpose: 
% CDF of multivariate normal distribution
% -----------------------------------
% Density:
% f(x) = (2*pi)^(-k/2) * det(cov_mat)^(-1/2) * exp(-(x-mu)'*inv(cov_mat)*(x-mu)/2)
% where k is the dimension of MVN
% E(X) = mu, Cov(X) = cov_mat
% -----------------------------------
% Algorithm: 
% GHK recusive simulator
% -----------------------------------
% Usage:
% X = points of evaluation (k*1)
% mu = mean vector of multivariate normal distribution (k*1)
% sigma = covariance matrix of multivariate normal distribution (k*k)
% ndraws = number of draws to simulate the probability
% -----------------------------------
% Returns:
% Prob = probability evaluated at points X
% -----------------------------------
% Notes:
% Support matrix input of X, mu, which should be k * n
% It will return a vector density with conformable size.
%
% Written by Hang Qian, Iowa State University
% Contact me:  matlabist@gmail.com

if nargin<4;    ndraws = 10000;                               end
if nargin<3;    sigma = eye(length(X));                       end
if nargin<2;    mu = 0;                                       end

% % Setting seeds of the simulator
% myseed = 20110710;
% try
%     RandStream.setDefaultStream(RandStream('mt19937ar','seed',myseed));
% catch
%     randn('seed',myseed);
%     rand('seed',myseed);
% end


% smart adjustment of matrix dimension
tranpose_flag = 0;
dim = size(sigma,1);
[nrow1,ncol1] = size(X);
if (nrow1 ~= dim) &&  (ncol1 == dim)
    X = X';
    [nrow1,ncol1] = size(X);
    tranpose_flag = 1;
end

[nrow2,ncol2] = size(mu);
if (nrow2 ~= dim) &&  (ncol2 == dim)
    mu = mu';
    [nrow2,ncol2] = size(mu);
    if nrow1 == 1
        tranpose_flag = 1;
    end
end

nobs = max(ncol1,ncol2);
if (nobs > ncol1) && (nrow1 > 1) 
    X = X(:,ones(nobs,1));
end

if (nobs > ncol2) && (nrow2 > 1) 
    mu = mu(:,ones(nobs,1));
end

% Normalize evaluation point
X_std_mat = X - mu;
P = chol(sigma);
if tranpose_flag == 1
    Prob = zeros(nobs,1);
else
    Prob = zeros(1,nobs);
end


% Recursive simulation from first to last,
% Convert MVN cdf to multiple one dimensional CDF
% Order: ub --->  Phi(ub)  ---> Y_sim
for r = 1:nobs
    Y_sim = zeros(ndraws,dim);
    X_std = X_std_mat(:,r);
    
    % First dimension
    ub = X_std(1) / P(1,1);
    prob_sim = NORM_CDF(ub);
    Y_sim(:,1) = NORM_INV(prob_sim * rand(ndraws,1));
    
    % 2 to (k-1) dimension
    for m = 2:dim-1
        %ub = (X_std(m)-Y_sim*P(:,m))/P(m,m);
        ub = (X_std(m) - Y_sim(:,1:m-1) * P(1:m-1,m)) / P(m,m);
        CDF = NORM_CDF(ub);
        prob_sim = prob_sim .* CDF;
        Y_sim(:,m) = NORM_INV(rand(ndraws,1) .* CDF);
    end
    
    % last dimension
    ub = (X_std(end) - Y_sim * P(:,end)) / P(end,end);
    prob_sim = prob_sim .* NORM_CDF(ub);
    
    % Take average
    Prob(r) = mean(prob_sim);
end

end


% -----------------------------------


% -----------------------------------
% -------   NORM_CDF  ---------
% -----------------------------------
function Prob = NORM_CDF(x)
Prob = 0.5 * erfc(-0.707106781186548 * x);
end


% -----------------------------------
% -------   NORM_INV  ---------
% -----------------------------------
function X = NORM_INV(Prob)
X = -1.41421356237310 * erfcinv(2*Prob);
end

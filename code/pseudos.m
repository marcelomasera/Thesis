%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate pseudo-observations  U[i][j] = R[i][j]/(n+1)
%
% INPUTS
%
% x : matrix of data (column vectors)
%
% OUTPUTS
% U : pseudo-observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [U] = pseudos(x)

% su = size(x);
% n  = su(1);
% d  = su(2);

U = pseudos_m(x);
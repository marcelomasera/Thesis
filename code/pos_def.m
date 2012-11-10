
function rhohat = pos_def(rho)
% Rescale matrix if indefinite
%
% Peter J. Rousseeuw and Geert Molenberghs. Transformation of non positive
% semidefinite correlation matrices. Communications in Statistics - Theory
% and Methods, 22(4):965–984, 1993.


[garbage,p] = chol(rho);

while(p~=0)
    
    % compute eigenvectors/-values
    [V,D]   = eig(rho);

    % replace negative eigenvalues by zero
    D       = max(D, 0);

    % reconstruct correlation matrix
    BB      = V * D * V';

    % rescale correlation matrix
    T       = 1 ./ sqrt(diag(BB));
    TT      = T * T';
    rho      = BB .* TT;
    
    rho(eye(size(rho,1))==1)=1;
    
    [garbage,p] = chol(rho);
    
end
    
rhohat=rho;
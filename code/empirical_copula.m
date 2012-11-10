

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Empirical copula
% Alexandre Beaulne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function C = empirical_copula(U)

    N = size(U,1);

    C = NaN(N,1);

    for i =1:N
   
       C(i) = sum(prod(double(U<=repmat(U(i,:),N,1)),2))/N;
   
    end
end

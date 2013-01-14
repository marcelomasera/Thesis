
% Empirical CDF of vector x at x

function U = pseudos(x)

    [N,d] = size(x);
    
    sorted = sort(x,1);
    
    for i = 1:d
        
        [uniq, idx] = unique(sorted(:,i),'last');
        
        for j = 1:N
            
            U(j,i) = idx(x(j,i)==uniq)/(N+1);
            
        end
        
    end
    
end
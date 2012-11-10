function theta = claytonfit(U)
    % Uses Kendall tau for 2D, Cherubini, Luciano and Vecchiato 2004 for D>2

    [n,m]=size(U);
    
    if(m==2)

        tau = corr(U,'type','Kendall');
        theta = 2*tau/(1-tau);
        
    elseif(m>2)
        
    %% initialize optimisation tuning parameters
%        options=optimset('Display','iter');
        options=optimset('Display','off');
%        options=optimset(options,'TolX',1e-36);
%        options=optimset(options,'MaxFunEvals',10000);

        problem.x1 = 0;
        problem.x2 = 100;
        problem.options = options;
        problem.solver = 'fminbnd';
        problem.objective = @(t) -LLH(U,t,n,m);
        
        theta = fminbnd(problem);
        
    else
        error('In Unxm, m must be 2 or higher');
    end
    
end

function l = LLH(U,t,n,m)

    l = n*(m*log(t)+log(gamma(1/t+m))-log(gamma(1/t)))-(t+1)*sum(sum(log(U)))-(1/t+m)*sum(log(sum(U.^(-t),2)-m+1),1);

end

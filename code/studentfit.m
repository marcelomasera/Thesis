
function [u,l,v] = studentfit(y)
%
% fit Student t distribution to a vector of observations
%
%   function [u,l,v] = studentfit(y)
%
% Alexandre Beaulne, october 2011
%

    % x(1) = u, x(2) = l, x(3) = v
    problem.objective = @(x) -sum(log(studentpdf(y,x(1),x(2),x(3))));
    problem.x0 = [mean(y) 1/std(y) 5]; % arbitrary initial parameter

    problem.options = optimset('Algorithm','interior-point',...
                            'Display','off',...
                            'TolFun',10^-9,...
                            'TolX',10^-9);

    problem.solver = 'fminsearch';

    x = fminsearch(problem);

    u = x(1);
    l = x(2);
    v = x(3);
end

function [rhohat,nuhat] = tcopulafit(U)
%
% Fit Student t copula to dataset, using method inspired by Quantitative
% Risk Management: Concepts, Techniques, and Tools by Alexander J. McNeil,
% Rüdiger Frey, & Paul Embrechts

    tau = corr(U,'type','Kendall');

    rhohat = sin(pi*tau/2);

    % make sure correlation matrix is positive definite
    rhohat = pos_def(rhohat);

    % compute nb. deg. freedom by MLE
    problem.objective = @(v) -sum(log(copulapdf('t',U,rhohat,v)));
    problem.x1 = 3;
    problem.x2 = 50;
    problem.options = optimset('Display','off');
    % problem.options = optimset(problem.options,'MaxFunEvals',200);
    problem.solver = 'fminbnd';
    nuhat = fminbnd(problem);
end

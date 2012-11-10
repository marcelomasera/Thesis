
function [tgtBalances,probMC,riskMeasure,errorflag] = cashmgmt(PnL_accounts,dxrates,marginsReq,tolerance,riskMeasure,alpha,options)
% Run the constrained optimization on data
%
% [tgtBalances,probMC,riskMeasure] = cashmgmt(PnL_accounts,dxrates,marginsReq,tolerance,riskMeasure,alpha,algo)
%
% Alexandre Beaulne, dec 2011

N = size(PnL_accounts,1);

marginsReq_mat = fastrepmat(marginsReq,N,1);

problem.x0 = (1.5*rand)*marginsReq;
problem.Aineq = [];
problem.bineq = [];
problem.Aeq = [];
problem.beq = [];
problem.lb = marginsReq;
problem.ub = 10*marginsReq;
problem.nonlcon = @(x) probMarginCall(x,tolerance);
problem.options = options;
problem.solver = 'fmincon';
  
if(strcmp(riskMeasure,'VaR'))
    % Value-at-Risk
    
    problem.objective = @(x) VaR(x-marginsReq);
          
    [tgtBalances,riskMeasure,errorflag] = fmincon(problem);
    [garbage,probMC] = probMarginCall(tgtBalances,0);
    
elseif(strcmp(riskMeasure,'TCE'))
    % Tail Conditional Expectation

    problem.objective = @(x) -TCE(x-marginsReq);
  
    [tgtBalances,riskMeasure,errorflag] = fmincon(problem);
    [garbage,probMC] = probMarginCall(tgtBalances,0);
	
elseif(strcmp(riskMeasure,'ETE'))
    % Expected tracking error
    
    problem.objective = @(x) mean(abs(dxrates*(x-marginsReq)'));
  
    [tgtBalances,riskMeasure,errorflag] = fmincon(problem);
    [garbage,probMC] = probMarginCall(tgtBalances,0);

end

% ---------------------- subfunctions -------------------------------------

    function output = VaR(surplus)
        % Value-at-Risk
    
        pnl = dxrates*surplus';
 
        output = -prctile(pnl,alpha*100);

    end

    function output = TCE(surplus)
        % Tail Conditional Expectation
    
        pnl = dxrates*surplus';
        
        output = mean(pnl(pnl<=prctile(pnl,alpha*100)));

    end

    function [p,peq] = probMarginCall(balances,offset)
            
        p = -1; % needed in nonlcon argument of fmincon...
    
        peq = sum(any(fastrepmat(balances,N,1)+PnL_accounts<marginsReq_mat,2))/N;

        peq = peq-offset;% offset is there for nonlcon argument of fmincon...

    end

% ---------------------- /subfunctions ------------------------------------

end


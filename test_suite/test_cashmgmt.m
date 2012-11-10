
function [tgtBalances,probMC,riskLevel,errorflag]=test_cashmgmt(metadata,data,params)

    %model = 'gaussian';
    model = 'scomdy';

    tolerance = 0.05;

    %riskMeasure = 'ETE'; % Expected tracking error
    riskMeasure = 'VaR'; % Value-at-Risk
    riskMeasure = 'TCE'; % Tail Conditional Expectation

    alpha = 0.05;

    N = 10000; % Number of simulated trajectories

    % initialize optimisation tuning parameters
    options = optimset('Display','iter-detailed');
    options = optimset(options,'TolCon',0.001);
    options = optimset(options,'DiffMinChange',1000);
    options = optimset(options,'DiffMaxChange',100000);
    options = optimset(options,'PlotFcns',@optimplotx);
    options = optimset(options,'Algorithm','interior-point');

    i = 1000;
    j = i+500;

    numAccounts = size(data.xrates,2);

    % Check if dates match
    if(params(i).date~=data.dates(j))
        error('Dates mismatch!');
    end

    mu = params(i).mu;
    Sigma = params(i).Sigma;
    contractsParam = params(i).contractsParam;
    xratesParam = params(i).xratesParam;
    rho = params(i).rho;
    nu = params(i).nu;

    tic
    disp('Simulating paths');
    if(strcmp(model,'gaussian'))
        [dContracts,dXRates] = simu(N,mu,Sigma,metadata);
    elseif(strcmp(model,'scomdy'))
        [dContracts,dXRates] = simu(N,contractsParam,xratesParam,rho,nu,metadata);
    else
        error('Invalid model name; has to be gaussian or scomdy')
    end
    
%     figure
%     hist(dContracts,50);
%     title('dContracts');
%     
%     figure
%     hist(dXRates,50);
%     title('dXRates');

    PnL_accounts = returns2prices(metadata,data.contractsPrices(j,:),data.nbContracts(j,:),dContracts);
    disp(strcat(num2str(toc),32,'seconds'));

    tic
    disp(strcat('Optimisation'));
    [tgtBalances,probMC,riskLevel,errorflag] = cashmgmt(PnL_accounts,dXRates,data.marginsReq(j,:),tolerance,riskMeasure,alpha,options);
    disp(strcat(num2str(toc),32,'seconds'));
end

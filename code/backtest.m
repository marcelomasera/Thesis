
function resultset = backtest(model,tolerance,riskMeasure,alpha,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Backtest optimization model. Recalibrate model
% everyday. Leave two years BUFFER at the beginning
% for first calibration.
%
% E.g. uses:
%
% resultset=backtest('scomdy',0.05,'VaR',0.05,20000)
%
% resultset=backtest('gaussian',0.05,'VaR',0.05,20000)
%
% resultset=backtest('scomdy',0.05,'ETE',0.05,20000)
%
% resultset=backtest('gaussian',0.05,'ETE',0.05,20000)
%
% resultset=backtest('scomdy',0.05,'TCE',0.05,20000)
%
% resultset=backtest('gaussian',0.05,'TCE',0.05,20000)
%
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize optimisation tuning parameters
options = optimset('Display','off');
options = optimset(options,'TolCon',0.001);
options = optimset(options,'DiffMinChange',1000);
options = optimset(options,'DiffMaxChange',100000);
options = optimset(options,'Algorithm','interior-point');

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000,'graphoff');

T = length(data.dates);
BUFFER=500;

filename=strcat('results_',model,'_');
filename=strcat(filename,riskMeasure);
filename=strcat(filename,'_tol_',int2str(100*tolerance));
filename=strcat(filename,'_alpha_',int2str(100*alpha));
filename=strcat(filename,'.mat');

% Check if backtest already began...
if(exist(filename,'file')==2)
    load(filename);
    startTime=find(isnan(resultset.date),1);
else
    startTime = 1;
    resultset.model = model;
    resultset.tolerance = tolerance;
    resultset.riskMeasure = riskMeasure;
    resultset.alpha = alpha;
    resultset.N = N;

    % declare matrices to hold FX PnL, # margin calls and maintenance aum
    resultset.date = NaN(1,T-BUFFER-1);
    resultset.tgtBalances = NaN(T-BUFFER-1,length(metadata.fxHeaders));
    resultset.errorflags = NaN(1,T-BUFFER-1);
    resultset.pnl_fx = NaN(1,T-BUFFER-1);
    resultset.margincall = NaN(1,T-BUFFER-1);
    resultset.aum = NaN(1,T-BUFFER-1);
end

load('calibrations');

numAccounts = size(data.xrates,2);

for i = startTime:T-BUFFER-1
    
    tic

    j = i+BUFFER;

    % Check if dates match
    if(params(i).date~=data.dates(j))
        error('Dates mismatch!');
    end

    if(strcmp(resultset.model,'gaussian'))
        [dContracts,dXRates] = simu(resultset.N,params(i).mu,params(i).Sigma,metadata);
    elseif(strcmp(resultset.model,'scomdy'))
        [dContracts,dXRates] = simu(resultset.N,params(i).contractsParam,params(i).xratesParam,params(i).rho,params(i).nu,metadata);
    else
        error('Invalid model name; has to be gaussian or scomdy')
    end

    PnL_accounts = returns2prices(metadata,data.contractsPrices(j,:),data.nbContracts(j,:),dContracts);

    [tgtBalances,garbage,garbage2,errorflag] = cashmgmt(PnL_accounts,dXRates,data.marginsReq(j,:),resultset.tolerance,resultset.riskMeasure,resultset.alpha,options);
    
    if(errorflag<=0)
        disp('Optimization didnt converge, trying once again');
        [tgtBalances,garbage,garbage2,errorflag] = cashmgmt(PnL_accounts,dXRates,data.marginsReq(j,:),resultset.tolerance,resultset.riskMeasure,resultset.alpha,options);
    end

    pnl_contracts = data.nbContracts(j,:).*(data.contractsPrices(j+1,:)-data.contractsPrices(j,:));
    PnL_accounts = NaN(1,numAccounts);

    for k = 1:numAccounts
        indices = strcmp(metadata.currencies,metadata.fxHeaders{k});
        PnL_accounts(k) = sum(pnl_contracts(indices),2);
    end

    resultset.date(i) = data.dates(j);
    resultset.tgtBalances(i,:) = tgtBalances;
    resultset.errorflags(i) = errorflag;
    resultset.pnl_fx(i) = (tgtBalances-data.marginsReq(j,:))*(data.xrates(j+1,:)-data.xrates(j,:))';
    resultset.margincall(i) = any(tgtBalances+PnL_accounts<data.marginsReq(j,:),2);
    resultset.aum(i) = (tgtBalances-data.marginsReq(j,:))*data.xrates(j,:)';

    save(filename,'resultset');

    disp(strcat('Backtesting, day',32,num2str(i),32,'of',32,num2str(T-BUFFER),', time required:',32,num2str(toc),32,'secs, erroflag:',32,num2str(errorflag)));
  
end

end


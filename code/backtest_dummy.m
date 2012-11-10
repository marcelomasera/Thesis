
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Backtest dummy heuristic model.
%
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

MULTIPLICATOR = 2;
BUFFER=501;

resultset.model = 'naive';

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000,'graphoff');

T = length(data.dates);

numMargins = size(data.contractsPrices,2)+size(data.xrates,2);

% declare matrices to hold FX PnL, # margin calls and maintenance AUM
resultset.date = NaN(1,T-BUFFER-1);
resultset.tgtBalances = NaN(T-BUFFER-1,length(metadata.fxHeaders));
resultset.pnl_fx = NaN(1,T-BUFFER-1);
resultset.margincall = NaN(1,T-BUFFER-1);
resultset.aum = NaN(1,T-BUFFER-1);

% balances = data.marginsReq(BUFFER,:);

for(t=BUFFER+1:T)
    
    disp(strcat('Backtesting, day',32,num2str(t-BUFFER),32,'of',32,num2str(T-buffer),', Elapsed time:',32,num2str(toc),32,'secs'));
    
    balances = MULTIPLICATOR*data.marginsReq(t-1,:);
    
    pnl_contracts = data.nbContracts(t-1,:).*...
        (data.contractsPrices(t,:)-data.contractsPrices(t-1,:));
  
    PnL_accounts = NaN(1,size(data.xrates,2));
    for(i=1:size(data.xrates,2))
        indices = strcmp(metadata.currencies,metadata.fxHeaders{i});
        PnL_accounts(i) = sum(pnl_contracts(indices),2);
    end
  
    resultset.date(t-BUFFER) = data.dates(t-1);
  
    resultset.tgtBalances(t-BUFFER,:) = balances;
  
    resultset.pnl_fx(t-BUFFER) = (balances-data.marginsReq(t-1,:))*(data.xrates(t,:)-data.xrates(t-1,:))';
  
    resultset.margincall(t-BUFFER) = any(balances+PnL_accounts<data.marginsReq(t-1,:),2);
  
    resultset.aum(t-BUFFER) = (balances-data.marginsReq(t-1,:))*data.xrates(t-1,:)';
  
%   % passive accumulation
%   balances=balances+PnL_accounts; 
%   
%   % answer margin calls 
%   balances(balances<data.marginsReq(t,:))=data.marginsReq(t,balances<data.marginsReq(t,:));
  
end

disp(strcat('Frequency margin call:',32,num2str(sum(resultset.margincall)/length(resultset.margincall))));

save('results_naive','resultset');

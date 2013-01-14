function [metadata,data] = loadData(tgtdate,tgtAUM)
% load and parse selected data from Sandrine Theroux's master file up to
% the tgtdate specified by the argument, the target AUM in USD specified in
% the tgtAUM argument, and displayMode is either 'graphon' or 'graphoff'.
%
% [metadata,data] = loadData(datenum('28-Dec-2012'),20000000)

try
    load('IndexData.mat',...
    'UsedContractsPrices',...
    'SymbolName',...
    'FXRates',...
    'Holidays',...
    'Notionnel',...
    'ContractsMargin',...
    'NbsContracts',...
    'HistoricalIndexValue')
catch
    error('Cannot find master file IndexData.mat in the current folder')
end

% currencies of the contracts
metadata.currencies = {'USD','USD','USD','USD','JPY','USD','CAD','USD',...
	'USD','USD','USD','EUR','USD','USD','USD','USD','USD','AUD','AUD',...
	'USD','USD','USD','USD'};

% notional of the futures
notionals = cell2mat(Notionnel(2,:));

% find index of non-USD contracts
nonUSD = [false ~strcmp(metadata.currencies,'USD')];

% save only data pertaining to nonUSD contracts
metadata.currencies = metadata.currencies(1,~strcmp(metadata.currencies,'USD'));
notionals = notionals(nonUSD(2:end));

% isolate headers
metadata.contractsHeaders = UsedContractsPrices(1,nonUSD);
metadata.contractsNames = SymbolName(2,nonUSD(2:end));
metadata.fxHeaders = FXRates(1,2:end);

% extract currency symbol from name of exchange rate
for i = 1:length(metadata.fxHeaders)
    temp = metadata.fxHeaders{i};
    metadata.fxHeaders{i} = temp(4:6);
end

% extract tgtdates avalaibles for both futures and fx rates
data.dates = intersect(cell2mat(UsedContractsPrices(2:end,1)),...
    cell2mat(FXRates(2:end,1)));
  
% set max tgtdate to argument tgtdate
data.dates = data.dates(data.dates<=tgtdate);

% remove holidays
data.dates = setdiff(data.dates,Holidays);

% remove weekends
days = weekday(data.dates);
data.dates = data.dates(days~=1 & days~=7);

N = length(data.dates);

% extract contracts prices
indices = logical([0;ismember(cell2mat(UsedContractsPrices(2:end,1)),data.dates)]);
data.contractsPrices = cell2mat(UsedContractsPrices(indices,nonUSD));

% adjust prices by notional
data.contractsPrices = data.contractsPrices.*repmat(notionals,N,1);

% extract foreign exchange rates
indices = logical([0;ismember(cell2mat(FXRates(2:end,1)),data.dates)]);
data.xrates = cell2mat(FXRates(indices,2:end)).^(-1);

% extract historical index level
indices = logical([0;ismember(cell2mat(HistoricalIndexValue(2:end,1)),data.dates)]);
histIndex = cell2mat(HistoricalIndexValue(indices,2));

% extract number of contracts (daily)
data.nbContracts = NaN(N,sum(nonUSD));
NbsContractsDates = cell2mat(NbsContracts(2:end,1));
NbsContracts = cell2mat(NbsContracts(2:end,logical([nonUSD 0 0])));

for i = 1:N
    maxDate = max(NbsContractsDates(NbsContractsDates<=data.dates(i)));
    data.nbContracts(i,:) = NbsContracts(NbsContractsDates==maxDate,:);
end

data.nbContracts = round(tgtAUM*data.nbContracts./...
    repmat(histIndex,1,size(data.nbContracts,2)));

% margins requirement of the contracts
marginsReq = cell2mat(ContractsMargin(3,:));
marginsReq = marginsReq(nonUSD(2:end));
marginsReq = repmat(marginsReq,length(data.dates),1);
marginsReq = marginsReq.*abs(data.nbContracts);

data.marginsReq = NaN(N,size(data.xrates,2));
for i = 1:size(data.xrates,2)
    indices = strcmp(metadata.currencies,metadata.fxHeaders{i});
    data.marginsReq(:,i) = sum(marginsReq(:,indices),2);
end

end

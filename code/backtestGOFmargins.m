
function backtestGOFmargins(margin,N,freqGOF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Backtest - Run parametric bootstrapping goodness-of-fit
% tests on marginal distributions every year.
%
% margin is 'AR1GARCH11', 'AR2GARCH22','EGARCH', 'GJR' and 'GARCH_t',
% N is the number of simulations in the parametric bootstrap,
% freqGOF is the frequency of the goodness-of-fit tests, in days, extending
% windows
%
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SPEC=SPECset(margin);

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000);

T=length(data.dates);

n = floor((T-500)/freqGOF)+1;

numMargins = size(data.contractsPrices,2)+size(data.xrates,2);

filename = strcat('backtest_GOF_',margin,'.mat');

if(exist(filename,'file')==2)
    load(filename);
    [garbage,startTime] = find(isnan(p'),1);
    if(isempty(startTime))
        startTime = size(p,1)+1;
    end
else
    % declare matrices to hold p-values of goodness-of-fit tests
    p = NaN(n,numMargins);
    startTime = 1;
end

dates = [];

tic;

for i = startTime:n
  
    t = freqGOF*(i+1);
  
    % log returns
    dC = log(data.contractsPrices(2:t,:)./data.contractsPrices(1:t-1,:));
    dr = log(data.xrates(2:t,:)./data.xrates(1:t-1,:));
    dX = [dC dr];

    for j = 1:numMargins
        disp(strcat('time slice',32,int2str(i),32,'out of',32,int2str(n),', margin',32,int2str(j),32,'out of',32,int2str(numMargins),', elapsed time:',32,num2str(toc/60),32,'min'));
        [p(i,j),N,SPEC] = GOFmargins(dX(:,j),N,SPEC);
    end
  
    dates = [dates; data.dates(t)];

    save(filename,'margin','dates','p','N');

end

end


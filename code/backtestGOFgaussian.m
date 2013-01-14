
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Backtest - Run parametric bootstrapping goodness-of-fit
% tests on multivariate gaussian, once every year.
%
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[metadata,data] = loadData(datenum('28-Dec-2012'),20000000);

freqGOF = 250;

N = 100; % number simulations parametric bootstrap

T = length(data.dates);

n = floor((T-500)/freqGOF)+1;

numMargins = size(data.contractsPrices,2)+size(data.xrates,2);

if(exist('backtest_GOF_gaussian.mat','file')==2)
    load('backtest_GOF_gaussian');
    startTime = find(isnan(p),1);
    if(isempty(startTime))
        startTime = length(p)+1;
    end
else
    % declare matrices to hold p-values of goodness-of-fit tests
    p = NaN(n,1);
    startTime = 1;
end

for(i=startTime:n)
  
    disp(strcat('iteration',32,int2str(i),32,'of',32,int2str(n)));
  
    t = freqGOF*(i+1);
  
    % log returns
    dC = log(data.contractsPrices(2:t,:)./data.contractsPrices(1:t-1,:));
    dr = log(data.xrates(2:t,:)./data.xrates(1:t-1,:));
    dX = [dC dr];
  
    p(i) = GOF_MVN(dX,N);

    save('backtest_GOF_gaussian','p','N');

end


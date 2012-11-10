function [p,N] = backtestGOFcopula(margin,copula,N,freqGOF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Backtest - Run parametric bootstrapping goodness-of-fit
% tests on copula, once every year.
%
% margin is 'AR1GARCH11', 'AR2GARCH22','EGARCH', 'GJR' or 'GARCH_t',
% copula is 'gaussian', 'student', 'clayton', 'gumbel' or 'frank',
% N is the number of simulations in the parametric bootstrap,
% freqGOF is the frequency of the goodness-of-fit tests, in days, extending
% windows
%
% e.g.:
%
% [p,N] = backtestGOFcopula('GARCH_t','student',100,250)
%
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BUFFER=500;

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000);

T = length(data.dates);

n = floor((T-BUFFER)/freqGOF)+1;

numMargins = size(data.contractsPrices,2)+size(data.xrates,2);

filename=strcat('backtest_GOF_',margin,'_',copula,'.mat');

if(exist(filename,'file')==2)
    load(filename);
    startTime = find(isnan(p),1);
    if(isempty(startTime))
        startTime = length(p)+1;
    end
else
    % declare matrix to hold p-values of goodness-of-fit tests
    p = NaN(n,1);
    startTime = 1;
end

SPEC=SPECset(margin);

for i = startTime:n
  
    disp(strcat(copula,32,'copula, timeslice',32,int2str(i),32,'of',32,int2str(n)));
  
    t = BUFFER+freqGOF*(i-1);
  
    % log returns
    dC = log(data.contractsPrices(2:t,:)./data.contractsPrices(1:t-1,:));
    dr = log(data.xrates(2:t,:)./data.xrates(1:t-1,:));
    dX = [dC dr];
  
    z = NaN(size(dX));

    for j = 1:numMargins
        [SPECS(j).SPEC,garbage2,garbage3,Innovations,Sigmas] = garchfit(SPEC,dX(:,j));
        z(:,j) = Innovations./Sigmas;
    end
  
    p(i)=GOFcopula(copula,z,N);

    save(filename,'p','N');

end


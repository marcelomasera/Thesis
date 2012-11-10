
%SPEC = garchset('VarianceModel','GARCH');
%% SPEC = garchset(SPEC,'Distribution','Gaussian');
%SPEC = garchset(SPEC,'Distribution','T');
%SPEC = garchset(SPEC,'Q',1);
%SPEC = garchset(SPEC,'P',1);
%SPEC = garchset(SPEC,'R',1);
%SPEC = garchset(SPEC,'Display','off');
%SPEC = garchset(SPEC,'MaxFunEvals',10000);
%SPEC = garchset(SPEC,'MaxIter',1000);

% [garbage,garbage,dX] = garchsim(SPEC,1500,1);

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000,'graphoff');

dX = log(data.contractsPrices(2:end,3)./data.contractsPrices(1:end-1,3));
% dX = log(data.xrates(2:end,3)./data.xrates(1:end-1,3));

[p,N,SPEC] = GOFmargins(dX,100,SPEC);

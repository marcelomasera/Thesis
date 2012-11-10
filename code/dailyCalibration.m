%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate models daily, save parameters in .mat file
% Alexandre Beaulne, Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;

BUFFER = 500;

% Check if calibration already began...
if(exist('calibrations.mat','file')==2)
    load('calibrations');
    startTime = length(params)+1;
else
    startTime = 1;
end

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000,'graphoff');

N = length(data.dates);

for(i = startTime:N-BUFFER)
    
    disp(strcat('Calibrating day',32,num2str(i),32,'of',32,num2str(N-BUFFER),', Elapsed time:',32,num2str(toc),32,'secs'));

    contractsPrices = data.contractsPrices(1:i+BUFFER-1,:);
    xrates = data.xrates(1:i+BUFFER-1,:);
    
    [a,b,c,d] = calibrateModel(contractsPrices,xrates,'scomdy');
    
    [e,f] = calibrateModel(contractsPrices,xrates,'gaussian');
    
    params(i).date = data.dates(i+BUFFER);
    
    params(i).contractsParam = a;
    params(i).xratesParam = b;
    params(i).rho = c;
    params(i).nu = d;
    
    params(i).mu = e;
    params(i).Sigma = f;
    
    save('calibrations', 'params');    
    
end

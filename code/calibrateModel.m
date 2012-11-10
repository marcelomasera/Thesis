
function varargout = calibrateModel(contractsPrices,xrates,model)
% calibrate marginal distribution and
% chosen copula to data in input struct.
% data is the structure returned by loadData.m
% model is either 'gaussian' or 'scomdy'.
%
% [contractsParam,xratesParam,rho,nu] = calibrateModel(contractsPrices,xrates,'scomdy')
%
%                           - OR -
%
% [mu,Sigma] = calibrateModel(contractsPrices,xrates,'gaussian')
%
% Alexandre Beaulne, dec. 2011

numContracts = size(contractsPrices,2);
numXRates = size(xrates,2);
N = length(xrates);

% compute log returns
dC = log(contractsPrices(2:end,:)./contractsPrices(1:end-1,:));
dr = log(xrates(2:end,:)./xrates(1:end-1,:));

if(strcmp(model,'scomdy'))

    U = NaN(N-1,numContracts+numXRates);

    % -------------------- margin distribution parameters -------------------

    SPEC = garchset('VarianceModel','GARCH');
    SPEC = garchset(SPEC,'R',1);
    SPEC = garchset(SPEC,'Q',1);
    SPEC = garchset(SPEC,'P',1);
    SPEC = garchset(SPEC,'Distribution','T');
    SPEC = garchset(SPEC,'Display','Off');
    SPEC = garchset(SPEC,'MaxFunEvals',10000);
    SPEC = garchset(SPEC,'MaxIter',1000);

    for i = 1:numContracts

        [contractsParam(i).SPEC,garbage1,garbage2,Innovations,Sigmas] = garchfit(SPEC,dC(:,i));
        contractsParam(i).SPEC.PreInnovations = Innovations;
        contractsParam(i).SPEC.PreSigmas = Sigmas;
        contractsParam(i).SPEC.PreSeries = dC(:,i);

        if(strcmp(contractsParam(i).SPEC.Distribution,'Gaussian'))
            U(:,i) = normcdf(Innovations./Sigmas);
        elseif(strcmp(contractsParam(i).SPEC.Distribution,'T'))
            U(:,i) = tcdf(Innovations./Sigmas,contractsParam(i).SPEC.DoF);
        else
            error('SPEC.Distribution is incorrect');
        end
    
    end

    for i = 1:numXRates
      
        [xratesParam(i).SPEC,garbage1,garbage2,Innovations,Sigmas] = garchfit(SPEC,dr(:,i));
        xratesParam(i).SPEC.PreInnovations = Innovations;
        xratesParam(i).SPEC.PreSigmas = Sigmas;
        xratesParam(i).SPEC.PreSeries = dC(:,i);

        if(strcmp(xratesParam(i).SPEC.Distribution,'Gaussian'))
            U(:,numContracts+i) = normcdf(Innovations./Sigmas);
        elseif(strcmp(xratesParam(i).SPEC.Distribution,'T'))
            U(:,numContracts+i) = tcdf(Innovations./Sigmas,xratesParam(i).SPEC.DoF);
        else
            error('SPEC.Distribution is incorrect');
        end
    
    end

% ------------------- / margin distribution parameters ------------------

% -------------------------- copula parameters --------------------------

    %fit student t copula to the timeseries
    [rhohat,nuhat] = tcopulafit(U);

    % fit mixture of gaussians copula to the timeseries
    %  [lambda,rho1,rho2] = mixGausscopulafit(U);

% ------------------------ / copula parameters --------------------------
  
    varargout{1} = contractsParam;
    varargout{2} = xratesParam;
    varargout{3} = rhohat;
    varargout{4} = nuhat;
  
elseif(strcmp(model,'gaussian'))
    dX = [dC dr];
    mu = mean(dX);
    Sigma = cov(dX);
  
    varargout{1} = mu;
    varargout{2} = Sigma;
else
    error('model argument must be either gaussian or scomdy');
end

end


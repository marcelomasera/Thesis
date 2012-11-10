
function [dContracts,dXRates] = simu(N,varargin)
% Simulate corrolated time-series
%
% [dContracts,dXRates]=simu(N,contractsParam,xratesParam,rho,nu,metadata)
%
%                               - OR -
%
%            [dContracts,dXRates]=simu(N,mu,Sigma,metadata)
%
% N is the number of draws for simulation,
% the other parameters are those returned by calibrateModel.m
%
% Alexandre Beaulne, dec 2011

metadata = varargin{end};

numContracts = length(metadata.contractsHeaders);
numXRates = length(metadata.fxHeaders);

dContracts = NaN(N,numContracts);
dXRates = NaN(N,numXRates);

if(nargin~=6&&nargin~=4)
    error('Incorrect number of arguments');
elseif(nargin==6)
    contractsParam = varargin{1};
    xratesParam = varargin{2};
    rho = varargin{3};
    nu = varargin{4};
    
    U = copularnd('t',rho,nu,N);
    % U = mixgaussianscopularnd(data.rho1,data.rho2,data.lambda,N);
    
%     y = norminv(U(:,i));

  for i = 1:numContracts
     y = tinv(U(:,i),contractsParam(i).SPEC.DoF);
     y = y./std(y);
     
     s2 = contractsParam(i).SPEC.K+contractsParam(i).SPEC.GARCH*contractsParam(i).SPEC.PreSigmas(end)^2+contractsParam(i).SPEC.ARCH*contractsParam(i).SPEC.PreInnovations(end)^2;
     epsilon = sqrt(s2)*y;
     dContracts(:,i) = contractsParam(i).SPEC.C+contractsParam(i).SPEC.AR*contractsParam(i).SPEC.PreSeries(end)+epsilon;

  end

  for j = 1:numXRates
      
     y = tinv(U(:,i+j),xratesParam(j).SPEC.DoF);
     y = y./std(y);
     
     s2 = xratesParam(j).SPEC.K+xratesParam(j).SPEC.GARCH*xratesParam(j).SPEC.PreSigmas(end)^2+xratesParam(j).SPEC.ARCH*xratesParam(j).SPEC.PreInnovations(end)^2;
     epsilon = sqrt(s2)*y;
     dXRates(:,j) = xratesParam(j).SPEC.C+xratesParam(j).SPEC.AR*xratesParam(j).SPEC.PreSeries(end)+epsilon;    
      
  end


elseif(nargin==4)
    
    mu = varargin{1};
    Sigma = varargin{2};

    R = mvnrnd(mu,Sigma,N);

    for i = 1:numContracts
        dContracts(:,i) = R(:,i);
    end

    for i = 1:numXRates
        dXRates(:,i) = R(:,i+numContracts);
    end
  
end

end

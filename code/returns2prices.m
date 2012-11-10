function PnL_accounts = returns2prices(metadata,contractsPrices,nbContracts,dContracts)

    N = size(dContracts,1);

    % returns in USD per contract
    returns = (exp(dContracts)-1).*fastrepmat(contractsPrices,N,1);

    % returns in USD for total each contracts
    PnL_contracts = returns.*fastrepmat(nbContracts,N,1);

    numXRates = length(metadata.fxHeaders);

    PnL_accounts = NaN(N,numXRates);
    for i = 1:numXRates
        indices = strcmp(metadata.currencies,metadata.fxHeaders{i});
        PnL_accounts(:,i) = sum(PnL_contracts(:,indices),2);
    end
end

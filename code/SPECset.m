
function SPEC = SPECset(margin)
    % margin is 'AR1GARCH11', 'AR2GARCH22','EGARCH', 'GJR' or 'GARCH_t'

    switch margin
        case 'AR1GARCH11'
            SPEC=garchset('VarianceModel','GARCH');
            SPEC=garchset(SPEC,'R',1);
            SPEC=garchset(SPEC,'Q',1);
            SPEC=garchset(SPEC,'P',1);
            SPEC=garchset(SPEC,'Distribution','Gaussian');
        case 'AR2GARCH22'
            SPEC=garchset('VarianceModel','GARCH');
            SPEC=garchset(SPEC,'R',2);
            SPEC=garchset(SPEC,'Q',2);
            SPEC=garchset(SPEC,'P',2);
            SPEC=garchset(SPEC,'Distribution','Gaussian');
        case 'EGARCH'
            SPEC=garchset('VarianceModel','EGARCH');
            SPEC=garchset(SPEC,'R',1);
            SPEC=garchset(SPEC,'Q',1);
            SPEC=garchset(SPEC,'P',1);
            SPEC=garchset(SPEC,'Distribution','Gaussian');
        case 'GJR'
            SPEC=garchset('VarianceModel','GJR');
            SPEC=garchset(SPEC,'R',1);
            SPEC=garchset(SPEC,'Q',1);
            SPEC=garchset(SPEC,'P',1);
            SPEC=garchset(SPEC,'Distribution','Gaussian');
        case 'GARCH_t'
            SPEC=garchset('VarianceModel','GARCH');
            SPEC=garchset(SPEC,'R',1);
            SPEC=garchset(SPEC,'Q',1);
            SPEC=garchset(SPEC,'P',1);
            SPEC=garchset(SPEC,'Distribution','T');
        otherwise
            error('Incorrect margin name');
    end

    SPEC = garchset(SPEC,'Display','off');
    SPEC = garchset(SPEC,'MaxFunEvals',20000);
    SPEC = garchset(SPEC,'MaxIter',5000);

end

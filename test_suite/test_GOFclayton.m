
n = 1000;
d = 9;
thetahat = 5;


SPEC = garchset('C',0.5,'K',0.05,'GARCH',0.4,'ARCH',0.4,'AR',0.05);

SPEC = garchset(SPEC,'VarianceModel','GARCH');

SPEC = garchset(SPEC,'R',1);
SPEC = garchset(SPEC,'Q',1);
SPEC = garchset(SPEC,'P',1);

% SPEC = garchset(SPEC,'Distribution','Gaussian');
SPEC = garchset(SPEC,'Distribution','T');
SPEC = garchset(SPEC,'DoF',7);

SPEC = garchset(SPEC,'Display','off');

for i = 1:d
    SPECS(i).SPEC = SPEC;
end

U = claytonrnd(thetahat,n,d);

z = NaN(n,d);

for i = 1:d

    if(strcmp(SPECS(i).SPEC.Distribution,'Gaussian'))
        y = norminv(U(:,i));
    elseif(strcmp(SPECS(i).SPEC.Distribution,'T'))
        y = tinv(U(:,i),SPECS(i).SPEC.DoF);
    else
        error('SPEC.Distribution is incorrect');
    end

    x = garchsim(SPECS(i).SPEC,n,1,y);
    [SPECS(i).SPEC,garbage2,garbage3,Innovations,Sigmas] = garchfit(SPECS(i).SPEC,x);
    z(:,i) = Innovations./Sigmas;
    
end

[pvalue,N] = GOFclayton(z,20,SPECS)


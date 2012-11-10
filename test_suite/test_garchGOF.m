
SPEC=garchset('C',0);
SPEC=garchset(SPEC,'VarianceModel','GARCH');
SPEC=garchset(SPEC,'Q',1);
SPEC=garchset(SPEC,'P',1);
SPEC=garchset(SPEC,'K',0.5);
SPEC=garchset(SPEC,'GARCH',0.4);
SPEC=garchset(SPEC,'ARCH',0.2);

[~,~,Series] = garchsim(SPEC,1000,1);

%plot(cumsum(Series))
%[Coeff,Errors,LLF,Innovations,Sigmas] = garchfit(Series);

p = garchGOF(Series)

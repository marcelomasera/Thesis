
SPEC = garchset('C',100,'K',20,'GARCH',0.9,'ARCH',0.05,'AR',0.2);

SPEC=garchset(SPEC,'VarianceModel','GARCH');
% SPEC=garchset(SPEC,'VarianceModel','EGARCH');
% SPEC=garchset(SPEC,'VarianceModel','GJR');
% SPEC=garchset(SPEC,'Leverage',0.3);

SPEC=garchset(SPEC,'R',1);
% SPEC=garchset(SPEC,'Q',1);
% SPEC=garchset(SPEC,'P',1);

% SPEC=garchset(SPEC,'R',2);
% SPEC=garchset(SPEC,'Q',2);
% SPEC=garchset(SPEC,'P',2);

% SPEC=garchset(SPEC,'Distribution','Gaussian');
SPEC=garchset(SPEC,'Distribution','T');
SPEC=garchset(SPEC,'DoF',7);

SPEC=garchset(SPEC,'Display','off');
% SPEC=garchset(SPEC,'MaxFunEvals',10000);
% SPEC=garchset(SPEC,'MaxIter',1000);

for i = 1:100
    
    [e,s,y] = garchsim(SPEC,1000,1);
    [Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(SPEC,y);
    
    if(Summary.exitFlag==-1)
        disp(strcat(int2str(i),32,'has NaN!'));
    else
        disp(strcat(int2str(i),32,'is OK'));
        i = i+1;
    end
    
end


% hist(Innovations,50)
% histfit(Innovations./Sigmas,50,'tlocationscale');
% title(strcat('Innovations, \mu=',num2str(mean(Innovations)),' \sigma=',num2str(sqrt(var(Innovations)))));
% 
% figure
% hist(Innovations./Sigmas,50)
% histfit(Innovations./Sigmas,50,'tlocationscale');
% title(strcat('epsilons, \mu=',num2str(u),' \sigma=',num2str(sqrt(1/l)),' \nu=',num2str(v)));


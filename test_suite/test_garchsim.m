
state1 = randn(10000,1);
state2 = state1;%randn(10000,1);

SPEC = SPECset('GARCH_t');
SPEC.AR = 1;
SPEC.K = 0.02;
SPEC.GARCH = 0.4;
SPEC.ARCH = 0.4;
SPEC.DoF = 7;

x1 = garchsim(SPEC,10000,1,state1);
x2 = garchsim(SPEC,10000,1,state2);

hist(abs(x1-x2),50);

figure

plot(x1(1:10),'ro');
hold on;
plot(x2(1:10),'bx');
    
% [garbage,garbage2,garbage3,Innovations,Sigmas] = garchfit(x1);
% 
% residuals = Innovations./Sigmas;
% 
% hist(abs(residuals-state1),50);
% 
% figure
% 
% plot(residuals(1:10),'ro');
% hold on;
% plot(state1(1:10),'bx');

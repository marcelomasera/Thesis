
theta = 5;

U = claytonrnd(theta,1000,9);

thetahat = claytonfit(U);

disp(strcat("theta: expected:', 32, num2str(theta), ", fitted:", 32, num2str(thetahat))); 

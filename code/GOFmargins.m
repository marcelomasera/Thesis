%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test the goodness-of-fit of GARCH models on a vector of log-returns,
% returns the p-value
%
% Alexandre Beaulne Dec. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p,N,SPEC] = GOFmargins(x,N,SPEC)

    if(size(x,1)>size(x,2))
        x = x';
    end

    n = length(x);
  
    [Coeff,garbage,garbage2,Innovations,Sigmas,Summary] = garchfit(SPEC,x);
  
  
    if(strcmp(SPEC.Distribution,'Gaussian'))
        cdf = @(z) normcdf(z,0,1);
    elseif(strcmp(SPEC.Distribution,'T'))
        cdf = @(z) tcdf(z,Coeff.DoF);
    else
        error('SPEC.Distribution is wrong');
    end
      
  
    % Summary
    z = Innovations./Sigmas;
  
    % Empirical cdf
    [garbage,order] = sort(z);
    [garbage,rank] = sort(order);
    Z = rank/n;
  
    % Theoretical cdf
    F = cdf(z);
  
    % Cramer von Mises stat
    Sn = ((Z-F)*(Z-F)')/n;
  
    [garbage,garbage,Series] = garchsim(Coeff,n,N);
  
    S = NaN(1,N);
  
    for i=1:N
      
        disp(strcat('Simulation',32,int2str(i),32,'of',32,int2str(N)));

        [Coeff,garbage,garbage2,Innovations,Sigmas] = garchfit(SPEC,Series(:,i));
        z = Innovations./Sigmas;

        % Empirical cdf
        [garbage,order] = sort(z);
        [garbage,rank] = sort(order);
        Z = rank/n;

        % Theoretical cdf
        F = cdf(z);

        % Cramer von Mises stat
        S(i) = ((Z-F)'*(Z-F))/n;
    end
  
    p = sum(S>Sn)/N;
  
end

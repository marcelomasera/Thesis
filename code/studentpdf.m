% Probability distribution function of Student distribution
function fx = studentpdf(x,u,l,v)
    % l=1/sigma^2
    fx=gamma((v+1)/2)*sqrt(l/(pi*v))*(1+l*(x-u).^2/v).^(-(v+1)/2)/gamma(v/2)';
end

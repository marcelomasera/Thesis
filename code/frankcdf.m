
function Y=frankcdf(U,theta)

    D=size(U,2);
    
    v=exp(-theta*U)-1;
    
    v0=exp(-theta)-1;
    
    Y=-log(1+prod(v,2)/(v0^(D-1)))/theta;

end
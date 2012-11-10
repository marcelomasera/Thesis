
function [p,N] = GOFcopula(copula,x,N)

    switch copula
        case 'gaussian'
            [p,N] = GOFgaussian(x,N);
        case 'student'
            [p,N] = GOFstudent(x,N);
        case 'clayton'
            [p,N] = GOFclayton(x,N);
        case 'gumbel'
            [p,N] = GOFgumbel(x,N);
        case 'frank'
            [p,N] = GOFfrank(x,N);
        otherwise
            error('Incorrect copula name');
    end

end

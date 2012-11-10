
function X = logrnd(p,N)
    % Simulate random variable from log series distribution with param alpha
    % Melchiori 2006
    
    c = log(1-p);
    X = NaN(N,1);
    
    for i = 1:N
        V = rand;
        if(V>=p)
            X(i) = 1;
            continue;
        else
            U = rand;
            q = 1-exp(c*U);
            if(V<=q^2)
                X(i) = floor(1+log(V)/log(q));
            elseif(q^2<V&&V<=q)
                X(i) = 1;
            else
                X(i) = 2;
            end
        end
    end
    
% % Simulate random variable from log series distribution with param alpha
% % Devroye 1987
% 
%     X = NaN(N,1);
%     
%     for i = 1:N
%         condn = true;
%         w = 1+P(p,1)/2;
%         
%         while(condn)
%             
%             U = rand;
%             W = rand;
%             temp = rand;
%             if(temp<0.5);
%                 S = -1;
%             else
%                 S = 1;
%             end
%             
%             if(U<=w/(1+w))
%                 V = rand;
%                 Y = V*w/P(p,1);
%             else
%                 E = random('exp',1);
%                 Y = (w+E)/P(p,1);
%             end
%             
%             X(i) = S*round(Y);
%             
%             if(W*min(1,exp(w-P(p,1)*Y))<=P(p,1+X(i))/P(p,1))
%                 X(i) = 1+X(i);
%                 condn = false;
%             end
%         end
%     end
end

% function y = P(p,k)
% 
%     if(k>=1)
%         y = p^k/(-log(1-p)*factorial(k));
%     else
%         y = 0;
%     end
% 
% end

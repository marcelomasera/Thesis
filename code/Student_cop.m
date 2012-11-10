%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%  Rosenblatt`s transform (P) and its inverse (Q) for
%%%  the Student copula
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function  [P,Q] = T_cop(u,v,rho,nu)

  a = tinv(v,nu); b = tinv(u,nu); r = sqrt(1-rho^2);  
  c = sqrt((nu+b.*b)/(nu+1));
  d = tinv(v,nu+1);
  rc = r*c;
  
  P = tcdf( (a-b*rho)./rc, nu+1);  
  Q = tcdf( b*rho + rc.*d, nu);


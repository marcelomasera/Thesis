
N = 20000;

d = 2;

U = rand(N,d);

Uhat = pseudos(U);

[U(1:10,:) Uhat(1:10,:)]

%if(sum(abs(Uhat-U)) < 0.02*N)
%    disp('pseudos(x) works!');
%end

% Plumbing script that generate the LaTeX tables from the results files

rowLabels = {'Japanese 10 Yr Future Mini','Can 10 Yr Future',...
    'Euro Bund Future','AUD 10 Yr Future','AU 1-3 year Future'...
    'AUD/USD'  'CAD/USD'  'EUR/USD'  'JPY/USD'};

%%%%%%%%%%%%%%% AR(1)-GARCH(1,1) Gaussian Innovations %%%%%%%%%%%%%%%%%%%%%

ar1garch11=open('backtest_GOF_AR1GARCH11.mat');

columnLabels=cellstr(datestr(ar1garch11.dates,12));

matrix2latex(ar1garch11.p', 'ar1garch11.tex',...
  'rowLabels', rowLabels,...
  'columnLabels', columnLabels,...
  'alignment', 'c',...
  'size', 'scriptsize',...
  'format', '%-6.2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% AR(2)-GARCH(2,2) Gaussian Innovations %%%%%%%%%%%%%%%%%%%%%

ar2garch22=open('backtest_GOF_AR2GARCH22.mat');

columnLabels=cellstr(datestr(ar2garch22.dates,12));

matrix2latex(ar2garch22.p', 'ar2garch22.tex',...
  'rowLabels', rowLabels,...
  'columnLabels', columnLabels,...
  'alignment', 'c',...
  'size', 'scriptsize',...
  'format', '%-6.2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% AR(1)-GARCH(1,1) Student Innovations %%%%%%%%%%%%%%%%%%%%%

ar1garch11=open('backtest_GOF_GARCH_t.mat');

columnLabels=cellstr(datestr(ar1garch11.dates,12));

matrix2latex(ar1garch11.p', 'ar1garch11_t.tex',...
  'rowLabels', rowLabels,...
  'columnLabels', columnLabels,...
  'alignment', 'c',...
  'size', 'scriptsize',...
  'format', '%-6.2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Copulas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowLabels={'MV Gaussian','AR(1)-GARCH(1,1) \& Gaussian copula',...
    'AR(1)-GARCH(1,1) \& Student copula','AR(1)-GARCH(1,1) \& Clayton copula',...
    'AR(1)-GARCH(1,1) \& Frank copula','AR(1)-GARCH(1,1) \& Gumbel copula'};


mvnorm=open('backtest_GOF_gaussian.mat');
gaussian=open('backtest_GOF_GARCH_t_gaussian.mat');
student=open('backtest_GOF_GARCH_t_student.mat');
clayton=open('backtest_GOF_GARCH_t_clayton.mat');
frank=open('backtest_GOF_GARCH_t_frank.mat');
gumbel=open('backtest_GOF_GARCH_t_gumbel.mat');

p=[mvnorm.p'; gaussian.p'; student.p'; clayton.p'; frank.p'; gumbel.p'];

matrix2latex(p, 'copulas.tex',...
  'rowLabels', rowLabels,...
  'columnLabels', columnLabels,...
  'alignment', 'c',...
  'size', 'scriptsize',...
  'format', '%-6.2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


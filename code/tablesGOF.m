

load('backtest_GOF_margins.mat');

data = loadData(datenum('06-Jan-2012'),20000000,'graphoff');

for i = 1:length(dates)
    rowLabels{i} = strcat(datestr(data.dates(1),12),32,'to',32,datestr(dates(i),12));
end

for i = 1:length(data.contractsNames)
    columnLabels{i} = data.contractsNames{i};
end

for j = 1:length(data.fxHeaders)
    columnLabels{i+j}=strcat(data.fxHeaders{j},'-USD');
end

matrix2latex(p, 'marginsGOF.tex',...
  'rowLabels', rowLabels,...
  'columnLabels', columnLabels,...
  'alignment', 'c',...
  'size', 'scriptsize',...
  'format', '%-6.2f');

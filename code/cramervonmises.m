% Just a quick demo of the Cramer von Mises' normality stat
X = randn(100,1);

[mu,sigma] = normfit(X);

range = max(X)-min(X);

nbins = 500;

x1 = min(X):range/nbins:max(X);
y1 = normcdf(x1,mu,sigma);

nbins = 25;

x2 = min(X):range/nbins:max(X);

y2 = NaN(length(x2),1);
for i=1:length(x2)
    y2(i) = mean(X<x2(i));
end

h = figure;
set(h,'Color',[1 1 1]);
hold on;

h1 = bar(x2,y2,1);
set(h1,'FaceColor',[190/255 190/255 190/255]);
set(h1,'EdgeColor',[210/255 210/255 210/255]);

h3 = plot(x1,y1,'k');
set(h3,'LineWidth',2);

legend('empirical','parametric','Location','NorthWest');

E = y2'-normcdf(x2,mu,sigma);
U = abs(min(zeros(length(x2),1),E'));
L = max(zeros(length(x2),1),E');
h2 = errorbar(x2,y2,L,U,'r');
set(h2,'LineStyle','none');

xlabel('x');
ylabel('cdf(x)');

export_fig cramervonmises -jpg -r300  


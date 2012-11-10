% Plot QQ plot (Mahalanobis distance) to show multivariate normality

[metadata,data] = loadData(datenum('28-Mar-2012'),20000000);

dC = log(data.contractsPrices(2:end,:)./data.contractsPrices(1:end-1,:));
dr = log(data.xrates(2:end,:)./data.xrates(1:end-1,:));

R = [dC dr];
[T,d] = size(R);
mu = mean(R);
S = cov(R);
Sinv = inv(S);
D2 = NaN(T,1);

for i = 1:T
    D2(i) = ((R(i)-mu)/S)*(R(i)-mu)';
end

PD = ProbDistUnivParam('gamma', [d/2 2]);

scrsz = get(0,'ScreenSize');
f = figure('Position',[scrsz(3)/4 scrsz(4)/6 scrsz(3)/3 scrsz(4)/2.5]);
set(f,'Color',[1 1 1]);
set(f, 'Renderer', 'painters')

h = qqplot(D2,PD);

set(h(1),'LineStyle','none');
set(h(1),'Color','k');
set(h(1),'Marker','+');
set(h(1),'MarkerEdgeColor','k');

set(h(3),'LineStyle','--');
set(h(3),'Color','k');
% set(h(2),'Marker','+');
% set(h(2),'MarkerEdgeColor','k');

% title('Graphical test of multivariate normality - QQ plot');
title('');
xlabel('\chi^2_{\nu} quantiles')
ylabel('Mahalanobis squared distances quantiles');
legend([h(3) h(1)],'Expected','Observed','Location','NorthWest');

export_fig mvQQplot -jpg -r300 -zbuffer


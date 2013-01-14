% Plot QQ plot (Mahalanobis distance) to show multivariate normality

[metadata,data] = loadData(datenum('28-Dec-2012'),20000000);

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

f = figure;
set(f,'Color',[1 1 1]);

h = qqplot(D2,PD);

xlim([-3 35]);

set(h(1),'LineStyle','none');
set(h(1),'Color','k');
set(h(1),'Marker','+');
set(h(1),'MarkerEdgeColor','k');

set(h(3),'LineStyle','--');
set(h(3),'Color','k');
set(h(2),'Marker','+');
set(h(2),'MarkerEdgeColor','k');
title('');
xlabel('$$\chi^2_{\nu}$$ quantiles','interpreter','latex');
ylabel('Mahalanobis squared distances quantiles');
legend([h(3) h(1)],'Expected','Observed','Location','NorthWest');

printfig(f,4,4,'mvQQplot','.eps',300)


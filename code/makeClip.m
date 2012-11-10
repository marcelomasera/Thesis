
[metadata,data] = loadData(datenum('28-Mar-2012'),20000000);

N = 50;

END = length(data.dates);
xmin = min(data.dates(END-N:END));
xmax = max(data.dates(END-N:END));

CAD = 1.4*data.marginsReq(END-N,2);
AUD = 1.4*data.marginsReq(END-N,1);

scrsz = get(0,'ScreenSize');
h = figure('Position',[0.1*scrsz(3) 0.05*scrsz(4) 0.85*scrsz(3) 0.85*scrsz(4)]);

for i = N:-1:0
  
clf;

subplot('position',[0.05 0.8 0.5 0.175]);
[ax,h1,h2] = plotyy(data.dates(END-N:END-i),...
                  data.contractsPrices(END-N:END-i,2)/1000,...
                  data.dates(END-N:END-i),...
                  data.nbContracts(END-N:END-i,2));
              
set(h1,'Color','b');
set(h1,'LineWidth',2);
set(h2,'Color','r');
set(h2,'LineWidth',2);

hold(ax(1), 'on');
datetick(ax(1),'x',12);
xlim(ax(1),[xmin xmax]);
% ylim(ax(1),[0.9*min(data.contractsPrices(END-N:END,2)) 1.1*max(data.contractsPrices(END-N:END,2))]);
ylabel(ax(1),'Price (000s CAD)');
set(ax(1),'YColor','k');

hold(ax(2), 'on');
datetick(ax(2),'x',12);
xlim(ax(2),[xmin xmax]);
% ylim(ax(2),[0.9*min(data.nbContracts(END-N:END,2)) 1.1*max(data.nbContracts(END-N:END,2))]);
ylabel(ax(2),'Holdings');
set(ax(2),'YColor','k');

legend('Price','Holdings','Location','NorthEast','Orientation','horizontal');
title('Can 10 Yr Future');

subplot('position',[0.05 0.55 0.5 0.175]);
[ax,h1,h2] = plotyy(data.dates(END-N:END-i),...
                  data.contractsPrices(END-N:END-i,3)/1000,...
                  data.dates(END-N:END-i),...
                  data.nbContracts(END-N:END-i,3));
set(h1,'Color','b');
set(h1,'LineWidth',2);
set(h2,'Color','r');
set(h2,'LineWidth',2);

hold(ax(1), 'on');
datetick(ax(1),'x',12);
xlim(ax(1),[xmin xmax]);
% ylim(ax(1),[0.9*min(data.contractsPrices(END-N:END,3)) 1.1*max(data.contractsPrices(END-N:END,3))]);
ylabel(ax(1),'Price (000s CAD)');
set(ax(1),'YColor','k');

hold(ax(2), 'on');
datetick(ax(2),'x',12);
xlim(ax(2),[xmin xmax]);
% ylim(ax(2),[0.9*min(data.nbContracts(END-N:END,3)) 1.1*max(data.nbContracts(END-N:END,3))]);
ylabel(ax(2),'Holdings');
set(ax(2),'YColor','k');

legend('Price','Holdings','Location','NorthEast','Orientation','horizontal');
title('Can 2 Yr Future');

subplot('position',[0.05 0.3 0.5 0.175]);
[ax,h1,h2] = plotyy(data.dates(END-N:END-i),...
                  data.contractsPrices(END-N:END-i,4)/1000,...
                  data.dates(END-N:END-i),...
                  data.nbContracts(END-N:END-i,4));
set(h1,'Color','b');
set(h1,'LineWidth',2);
set(h2,'Color','r');
set(h2,'LineWidth',2);

hold(ax(1), 'on');
datetick(ax(1),'x',12);
xlim(ax(1),[xmin xmax]);
% ylim(ax(1),[0.9*min(data.contractsPrices(END-N:END,4)) 1.1*max(data.contractsPrices(END-N:END,4))]);
ylabel(ax(1),'Price (000s AUD)');
set(ax(1),'YColor','k');

hold(ax(2), 'on');
datetick(ax(2),'x',12);
xlim(ax(2),[xmin xmax]);
% ylim(ax(2),[0.9*min(data.nbContracts(END-N:END,4)) 1.1*max(data.nbContracts(END-N:END,4))]);
ylabel(ax(2),'Holdings');
set(ax(2),'YColor','k');

legend('Price','Holdings','Location','NorthEast','Orientation','horizontal');
title('AUD 10 Yr Future');

subplot('position',[0.05 0.05 0.5 0.175]);
[ax,h1,h2] = plotyy(data.dates(END-N:END-i),...
                  data.contractsPrices(END-N:END-i,5)/1000,...
                  data.dates(END-N:END-i),...
                  data.nbContracts(END-N:END-i,5));
set(h1,'Color','b');
set(h1,'LineWidth',2);
set(h2,'Color','r');
set(h2,'LineWidth',2);

hold(ax(1), 'on');
datetick(ax(1),'x',12);
xlim(ax(1),[xmin xmax]);
% ylim(ax(1),[0.9*min(data.contractsPrices(END-N:END,5)) 1.1*max(data.contractsPrices(END-N:END,5))]);
ylabel(ax(1),'Price (000s AUD)');
set(ax(1),'YColor','k');

hold(ax(2), 'on');
datetick(ax(2),'x',12);
xlim(ax(2),[xmin xmax]);
% ylim(ax(2),[0.9*min(data.nbContracts(END-N:END,5)) 1.1*max(data.nbContracts(END-N:END,5))]);
ylabel(ax(2),'Holdings');
set(ax(2),'YColor','k');

legend('Price','Holdings','Location','NorthEast','Orientation','horizontal');
title('AUD 1-3 Yr Future');

subplot('position',[0.65 0.575 0.15 0.4]);
bar(0,CAD/1000,2);
hold on;
line([-1 1],[data.marginsReq(END-i,2)/1000 data.marginsReq(END-i,2)/1000],'LineWidth',4,'Color','r');
ylabel('(000s CAD)');
legend('posted collateral','min. margin reqs.','Location','EastOutside');
ylim([0 4*max(data.marginsReq(END-N:END,2)/1000)]);
CAD = CAD+data.nbContracts(END-i-1,2)*(data.contractsPrices(END-i,2)-data.contractsPrices(END-i-1,2));
CAD = CAD+data.nbContracts(END-i-1,3)*(data.contractsPrices(END-i,3)-data.contractsPrices(END-i-1,3));

subplot('position',[0.65 0.05 0.15 0.4]);
bar(0,AUD/1000,2);
hold on;
line([-1 1],[data.marginsReq(END-i,1)/1000 data.marginsReq(END-i,1)/1000],'LineWidth',4,'Color','r');
ylabel('(000s AUD)');
legend('posted collateral','min. margin reqs.','Location','EastOutside');
ylim([0 4*max(data.marginsReq(END-N:END,1)/1000)]);
AUD=AUD+data.nbContracts(END-i-1,4)*(data.contractsPrices(END-i,4)-data.contractsPrices(END-i-1,4));
AUD=AUD+data.nbContracts(END-i-1,5)*(data.contractsPrices(END-i,5)-data.contractsPrices(END-i-1,5));

M(N-i+1) = getframe(gcf);

end

movie2avi(M,'collateral','FPS',2,'COMPRESSION','Cinepak');



function plotResults(riskMeasure,alpha,tolerance,period,mode,color,print)
%
% plotResults('ETE',0.05,0.05,'complete','% collateral',true,true)
% plotResults('ETE',0.05,0.05,'crisis','% collateral',true,false)
%

%%%%%%%%%%%%%%%%%%% params to change %%%%%%%%%%%%%%%%%%%%%%
% riskMeasure='ETE';
% riskMeasure='VaR';
% riskMeasure='TCE';
% 
% alpha=0.05;
% 
% tolerance=0.05;
% 
% period='complete';
% period='crisis';
% 
% mode='USD';
% mode='% collateral';
% 
% color: true or false
%
% Print: true or false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Load and Clean Data %%%%%%%%%%%%%%%%%%%

load('results_naive');
date_dummy=resultset.date;
% tgtBalances_dummy=resultset.tgtBalances;
pnl_fx_dummy=resultset.pnl_fx;
margincall_dummy=resultset.margincall;
if(strcmp(mode,'% collateral'))
    pnl_fx_dummy=100*pnl_fx_dummy./resultset.aum;
end

load(strcat('results_gaussian_',riskMeasure,'_tol_',int2str(100*tolerance),'_alpha_',int2str(100*alpha)));
date_gaussian=resultset.date;
% tgtBalances_gaussian=resultset.tgtBalances;
pnl_fx_gaussian=resultset.pnl_fx;
margincall_gaussian=resultset.margincall;
if(strcmp(mode,'% collateral'))
    pnl_fx_gaussian=100*pnl_fx_gaussian./resultset.aum;
end

load(strcat('results_scomdy_',riskMeasure,'_tol_',int2str(100*tolerance),'_alpha_',int2str(100*alpha)));
date_scomdy=resultset.date;
% tgtBalances_scomdy=resultset.tgtBalances;
pnl_fx_scomdy=resultset.pnl_fx;
margincall_scomdy=resultset.margincall;
if(strcmp(mode,'% collateral'))
    pnl_fx_scomdy=100*pnl_fx_scomdy./resultset.aum;
end

if(sum(date_dummy~=date_gaussian)==0&&sum(date_gaussian~=date_scomdy)==0)
    dates=date_dummy;
    clear date_dummy date_gaussian date_scomdy;
else
    error('Dates vector mismatch');
end

if(strcmp(period,'crisis'))
    indices=[find(dates==datenum('17-Mar-2008'),1):find(dates==datenum('17-Feb-2009'),1)];
	dates=dates(indices);
else
    indices=[1:length(dates)];
end

T=length(indices);

% tgtBalances_dummy=tgtBalances_dummy(indices);
% tgtBalances_gaussian=tgtBalances_gaussian(indices);
% tgtBalances_scomdy=tgtBalances_scomdy(indices);

margincall_dummy=margincall_dummy(indices);
margincall_gaussian=margincall_gaussian(indices);
margincall_scomdy=margincall_scomdy(indices);

pnl_fx_dummy=pnl_fx_dummy(indices);
pnl_fx_gaussian=pnl_fx_gaussian(indices);
pnl_fx_scomdy=pnl_fx_scomdy(indices);

%%%%%%%%%%%%%%%%%%% /Load and Clean Data %%%%%%%%%%%%%%%%%%%

% --------------------------- Table ---------------------------------------

% results matrix
results=NaN(3,3);

results(2,1)=sum(margincall_dummy);
results(3,1)=sum(margincall_dummy)/T;

results(2,2)=sum(margincall_gaussian);
results(3,2)=sum(margincall_gaussian)/T;

results(2,3)=sum(margincall_scomdy);
results(3,3)=sum(margincall_scomdy)/T;

columnLabels={'Naive','MV Gaussian','AR-GARCH \& t copula'};

if(strcmp(riskMeasure,'ETE'))

    rowLabels={strcat('Avg. daily tracking error (',mode,')'),...
      strcat('\# of margin calls (out of',32,int2str(T),32,'days)'),...
      'Frequency of margin call'};
  
    results(1,1)=mean(abs(pnl_fx_dummy));
    results(1,2)=mean(abs(pnl_fx_gaussian));
    results(1,3)=mean(abs(pnl_fx_scomdy));

    matrix2latex(results, strcat('resultsETE_',period,'.tex'),...
      'rowLabels', rowLabels,...
      'columnLabels', columnLabels,...
      'alignment', 'c',...
      'size', 'small',...
      'format', '%-6.2f');
  
elseif(strcmp(riskMeasure,'VaR'))

    rowLabels={strcat('Realized daily VaR (',mode,')'),...
      strcat('\# of margin calls (out of',32,int2str(T),32,'days)'),...
      'Frequency of margin call'};
  
    results(1,1)=-prctile(pnl_fx_dummy,alpha*100);
    results(1,2)=-prctile(pnl_fx_gaussian,alpha*100);
    results(1,3)=-prctile(pnl_fx_scomdy,alpha*100);

    matrix2latex(results, strcat('resultsVaR_',period,'.tex'),...
      'rowLabels', rowLabels,...
      'columnLabels', columnLabels,...
      'alignment', 'c',...
      'size', 'small',...
      'format', '%-6.2f');
  elseif(strcmp(riskMeasure,'TCE'))

    rowLabels={strcat('Avg. daily tail loss (',mode,')'),...
      strcat('\# of margin calls (out of',32,int2str(T),32,'days)'),...
      'Frequency of margin call'};
  
    results(1,1)=mean(pnl_fx_dummy(pnl_fx_dummy<=prctile(pnl_fx_dummy,alpha*100)));
    results(1,2)=mean(pnl_fx_gaussian(pnl_fx_gaussian<=prctile(pnl_fx_gaussian,alpha*100)));
    results(1,3)=mean(pnl_fx_scomdy(pnl_fx_scomdy<=prctile(pnl_fx_scomdy,alpha*100)));

    matrix2latex(results, strcat('resultsTCE_',period,'.tex'),...
      'rowLabels', rowLabels,...
      'columnLabels', columnLabels,...
      'alignment', 'c',...
      'size', 'small',...
      'format', '%-6.2f');
else
    error('Incorrect risk measure');
end
% --------------------------- /Table --------------------------------------

% --------------------------- Plot 1 --------------------------------------

xmin=min(dates);
xmax=max(dates);

scrsz = get(0,'ScreenSize');
h=figure('Position',[scrsz(3)/4 scrsz(4)/6 scrsz(3)/2 scrsz(4)/1.5]);
set(h,'Color',[1 1 1]);
set(h, 'Renderer', 'painters')

subplot(3,1,1)
ymax=1.1*max(pnl_fx_dummy);
ymin=1.1*min(pnl_fx_dummy);
h2=bar(dates,pnl_fx_dummy);
ylabel(strcat('PnL (',mode,')'));
datetick('x',10);
title('Naive strategy');
axis([xmin xmax ymin ymax]);

subplot(3,1,2)
ymax=1.1*max(pnl_fx_gaussian);
ymin=1.1*min(pnl_fx_gaussian);
h3=bar(dates,pnl_fx_gaussian);
datetick('x',10);
ylabel(strcat('PnL (',mode,')'));
title('Static multivariate normal model');
axis([xmin xmax ymin ymax])

subplot(3,1,3)
ymax=1.1*max(pnl_fx_scomdy);
ymin=1.1*min(pnl_fx_scomdy);
h4=bar(dates,pnl_fx_scomdy);
datetick('x',10)
ylabel(strcat('PnL (',mode,')'));
title('Copula-based MV dynamic model');
axis([xmin xmax ymin ymax]);

if(color)
    % do smtg
else
    set(h2,'FaceColor',[175/255 175/255 175/255]);
    set(h3,'FaceColor',[175/255 175/255 175/255]);
    set(h4,'FaceColor',[175/255 175/255 175/255]);
    
    set(h2,'EdgeColor','k');
    set(h3,'EdgeColor','k');
    set(h4,'EdgeColor','k');
end

if(print)
    % saveas(h,'dailyPnLfx.jpg')
    export_fig dailyPnLfx -jpg -r300 -zbuffer
end

% --------------------------- /Plot 1 -------------------------------------

% --------------------------- Plot 2 --------------------------------------

if(strcmp(riskMeasure,'ETE'))
    
    h4=figure;
    set(h4,'Color',[1 1 1]);
    hold on;
    set(gca,'YScale','log');

    xmax=max(abs([pnl_fx_gaussian pnl_fx_scomdy]));
    x= 0:xmax/50:xmax;

    n1=hist(abs(pnl_fx_gaussian),x);
    ymax=max(n1);

    n2=hist(abs(pnl_fx_scomdy),x);
    ymax=1.1*max(ymax,max(n2));

    h1=bar(x,n1,1,'k');
    set(h1,'EdgeColor','none')
    h2=bar(x,n2,1);
    set(h2,'FaceColor',[175/255 175/255 175/255])
    set(h2,'BarWidth',0.6);
%     h3=bar(x(n1<n2),n1(n1<n2),1);
%     set(h3,'FaceColor','none')

    legend('Static multivariate normal','Copula-based MV dynamic model');
    axis([0 xmax 0 ymax])
    xlabel(strcat('Daily tracking error (',mode,')'))
    ylabel(strcat('Frequency (out of',32,int2str(T),32,'days)'))

    if(print)
        export_fig histETE -jpg -r300
    end

elseif(strcmp(riskMeasure,'VaR'))
    
    h4=figure;
    set(h4,'Color',[1 1 1]);
    hold on;
    set(gca,'YScale','log');

    xmin=min([pnl_fx_gaussian pnl_fx_scomdy]);
    x=[xmin:-xmin/50:0];

    n1=hist(pnl_fx_gaussian(pnl_fx_gaussian<0),x);
    ymax=max(n1);

    n2=hist(pnl_fx_scomdy(pnl_fx_scomdy<0),x);
    ymax=max(ymax,max(n2));

    h1=bar(x,n1,1,'k');
    set(h1,'EdgeColor','none')
    h2=bar(x,n2,1);
    set(h2,'FaceColor',[175/255 175/255 175/255])

    legend('Static multivariate normal','Copula-based MV dynamic model','Location','NorthWest');
    axis([xmin 0 0 1.1*ymax])
    xlabel(strcat('Losses (',mode,')'))
    ylabel(strcat('Frequency (out of',32,int2str(T),32,'days)'))
    
%     h5=bar(prctile(pnl_fx_gaussian,alpha*100),ymax,1,'k');
%     set(h5,'EdgeColor','none')
    
%     h6=bar(prctile(pnl_fx_scomdy,alpha*100),ymax,1);
%     set(h6,'EdgeColor','none')
    
%     change xtick

%     if(print)
%         export_fig histVaR -jpg -r300
%     end

elseif(strcmp(riskMeasure,'TCE'))
    
    h4=figure;
    set(h4,'Color',[1 1 1]);
    hold on;
    set(gca,'YScale','log');

    xmin=min([pnl_fx_gaussian pnl_fx_scomdy]);
    xmax=max([pnl_fx_gaussian(pnl_fx_gaussian<=prctile(pnl_fx_gaussian,alpha*100)) pnl_fx_scomdy(pnl_fx_scomdy<=prctile(pnl_fx_scomdy,alpha*100))]);
    x=xmin:-xmin/50:0;

    n1=hist(pnl_fx_gaussian(pnl_fx_gaussian<=prctile(pnl_fx_gaussian,alpha*100)),x);
    ymax=max(n1);

    n2=hist(pnl_fx_scomdy(pnl_fx_scomdy<=prctile(pnl_fx_scomdy,alpha*100)),x);
    ymax=1.1*max(ymax,max(n2));

    h1=bar(x,n1,1,'k');
    set(h1,'EdgeColor','none')
    h2=bar(x,n2,0.8);
    set(h2,'FaceColor',[175/255 175/255 175/255])

    legend('Static multivariate normal','Copula-based MV dynamic model');
    axis([1.1*xmin 0.9*xmax 0 ymax])
    xlabel(strcat(num2str(alpha*100),'% worst losses (',mode,')'))
    ylabel(strcat('Frequency (out of',32,int2str(T),32,'days)'))

%     if(print)
%         export_fig histTCE -jpg -r300
%     end

else
    error('Incorrect risk measure');
end

% --------------------------- /Plot 2 -------------------------------------

end









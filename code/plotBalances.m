
function plotBalances(metadata,data,riskMeasure,alpha,tolerance,color,print)
%
% [metadata,data] = loadData(datenum('28-Dec-2012'),20000000);
%
% plotBalances(metadata,data,'TCE',0.05,0.05,false,true)
%

%%%%%%%%%%%%%%%%%%% params to change %%%%%%%%%%%%%%%%%%%%%%
% riskMeasure: 'ETE' or 'VaR' or 'TCE'
% alpha: 0.05
% tolerance: 0.05
% color = true or false
% print = true of false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Load and Clean Data %%%%%%%%%%%%%%%%%%%

load(strcat('results_gaussian_',riskMeasure,'_tol_',int2str(100*tolerance),'_alpha_',int2str(100*alpha)));
date_gaussian = resultset.date;
tgtBalances_gaussian = resultset.tgtBalances;

load(strcat('results_scomdy_',riskMeasure,'_tol_',int2str(100*tolerance),'_alpha_',int2str(100*alpha)));
date_scomdy = resultset.date;
tgtBalances_scomdy = resultset.tgtBalances;

if(sum(date_gaussian~=date_scomdy)==0)
    dates = date_gaussian;
    clear date_gaussian date_scomdy;
else
    error('Dates vector mismatch');
end

%%%%%%%%%%%%%%%%%%% /Load and Clean Data %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%

scrsz = get(0,'ScreenSize');
h = figure('Position',[0.25*scrsz(3) 0.05*scrsz(4) 0.45*scrsz(3) 0.85*scrsz(4)]);
set(h,'Color',[1 1 1]);
set(h, 'Renderer', 'painters')

n = length(metadata.fxHeaders);

for i = 1:n
    
    marginReq = data.marginsReq(ismember(data.dates,dates),i);

    subplot(n,1,i);
    hold on;
    
    y = 100*(tgtBalances_scomdy(:,i)-tgtBalances_gaussian(:,i))./marginReq;
    
    h1 = bar(y);
    set(h1,'BarWidth',1);
    set(h1,'EdgeColor','none');
    ylabel(metadata.fxHeaders{i});
    xlim([0 length(y)]);
    m = max(abs(y));
    ylim([-1.1*m 1.1*m]);
    
    idx = datevec(dates);
    idx = find(diff(idx(:,1)))+1;
    set(gca,'xtick',idx);
    set(gca,'xticklabel',datestr(dates(idx),10));

    if(color)
        set(h1,'FaceColor','b');
    else
        set(h1,'FaceColor','k');
%         set(h1,'FaceColor',[175/255 175/255 175/255]);
    end

end

if(print)
    printfig(h,7,9,'tgtBalances','.eps',300)
end

end

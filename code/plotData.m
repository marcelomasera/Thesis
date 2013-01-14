
function plotData(metadata,data,color)
%
% plotData(metadata,data,true)
%
% plotData(metadata,data,false)

%%%%%%%%%%%%%%%%%%%%%%%%% Fig 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    h = figure('Position',[100 100 400 800],'Visible','off');
    set(h,'Color',[1 1 1]);
    n = length(metadata.contractsNames);
    for i = 1:n
        subplot(n,1,i);
        [ax,h1,h2] = plotyy(data.dates,...
                          data.contractsPrices(:,i)/1000,...
                          data.dates,...
                          data.nbContracts(:,i));
        title(metadata.contractsNames{i});

        xmin = min(data.dates);
        xmax = max(data.dates);

        hold(ax(1), 'on');
        datetick(ax(1),'x',10);
        xlim(ax(1),[xmin xmax]);
        ylabel(ax(1),strcat('Price (000s',32,metadata.currencies{i},')'));
        set(ax(1),'YColor','k');

        hold(ax(2), 'on');
        datetick(ax(2),'x',10);
        xlim(ax(2),[xmin xmax]);
        ylabel(ax(2),'Holdings');
        set(ax(2),'YColor','k');

        legend('Price','Holdings','Location','NorthWest','Orientation','horizontal');
        
        if(color)
            set(h1,'LineStyle','-')
            set(h1,'LineWidth',2)
            set(h1,'Color','b')
            set(h2,'LineStyle','--')
            set(h2,'LineWidth',2)
            set(h2,'Color','r') 
        else
            set(h1,'LineStyle','-')
            set(h1,'Color','k')
            set(h2,'LineStyle',':')
            set(h2,'Color','k')            
        end

    end

    printfig(h,8,12,'contractsprices','.eps',300);
    close(h);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fig 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    h3 = figure('Position',[50 50 300 500],'Visible','off');
    set(h3,'Color',[1 1 1]);
    n = length(metadata.fxHeaders);
    for i = 1:n
        subplot(n,1,i);
        h = plot(data.dates,data.xrates(:,i));

        ylabel(strcat(metadata.fxHeaders{i},'/USD'));

        xmin = min(data.dates);
        xmax = max(data.dates);

        datetick('x',10);
        xlim([xmin xmax]);
        
        if(color)
            set(h,'Color','b')
        else
            set(h,'Color','k')            
        end

    end
    
    printfig(h3,8,10,'exchangerates','.eps',300);
    close(h3);

end

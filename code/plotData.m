
function plotData(metadata,data,color,mode)
%
% plotData(metadata,data,true,'pres')
%
% plotData(metadata,data,false,'thesis')

scrsz = get(0,'ScreenSize');

%%%%%%%%%%%%%%%%%%%%%%%%% Fig 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(mode,'thesis'))
  
    h = figure('Position',[0.25*scrsz(3) 0.05*scrsz(4) 0.4*scrsz(3) 0.85*scrsz(4)]);
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
        datetick(ax(1),'x',11);
        xlim(ax(1),[xmin xmax]);
        ylabel(ax(1),strcat('Price (000s',32,metadata.currencies{i},')'));
        set(ax(1),'YColor','k');

        hold(ax(2), 'on');
        datetick(ax(2),'x',11);
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

%     printfig(h,8,12,'contractsprices','.jpg')
    export_fig('contractsprices','-jpg','-r300');
    
elseif(strcmp(mode,'pres'))
    
    n = length(metadata.contractsHeaders);
    for i = 1:n
        h = figure('Position',[0.25*scrsz(3) 0.25*scrsz(4) 0.6*scrsz(3) 0.4*scrsz(4)]);
        set(h,'Color',[1 1 1]);
        [ax,h1,h2] = plotyy(data.dates,...
                          data.contractsPrices(:,i)/1000,...
                          data.dates,...
                          data.nbContracts(:,i));
        title(metadata.contractsNames{i});

        xmin = min(data.dates);
        xmax = max(data.dates);

        hold(ax(1), 'on');
        datetick(ax(1),'x',11);
        xlim(ax(1),[xmin xmax]);
        ylabel(ax(1),strcat('Price (000s',32,metadata.currencies{i},')'));
        set(ax(1),'YColor','k');

        hold(ax(2), 'on');
        datetick(ax(2),'x',11);
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
        
        export_fig(metadata.contractsHeaders{i},'-jpg','-r200');

    end
    
else
    error('Incorrect mode');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fig 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(mode,'thesis'))
    
    h3 = figure('Position',[0.25*scrsz(3) 0.05*scrsz(4) 0.4*scrsz(3) 0.85*scrsz(4)]);
    set(h3,'Color',[1 1 1]);
    n = length(metadata.fxHeaders);
    for i = 1:n
        subplot(n,1,i);
        h = plot(data.dates,data.xrates(:,i));

        ylabel(strcat(metadata.fxHeaders{i},'/USD'));

        xmin = min(data.dates);
        xmax = max(data.dates);

        datetick('x',11);
        xlim([xmin xmax]);
        
        if(color)
            set(h,'Color','b')
        else
            set(h,'Color','k')            
        end

    end

    %   printfig(h3,6,10,'exchangerates','.jpg')
    export_fig 'exchangerates' -jpg -r300
    
elseif(strcmp(mode,'pres'))
    
    n=length(metadata.fxHeaders);
    for i = 1:n
        
        h3 = figure('Position',[0.25*scrsz(3) 0.25*scrsz(4) 0.6*scrsz(3) 0.4*scrsz(4)]);
        set(h3,'Color',[1 1 1]);

        h = plot(data.dates,data.xrates(:,i));

        ylabel(strcat(metadata.fxHeaders{i},'/USD'));

        xmin = min(data.dates);
        xmax = max(data.dates);

        datetick('x',11);
        xlim([xmin xmax]);
        
        if(color)
            set(h,'Color','b')
        else
            set(h,'Color','k')            
        end
        
        %   printfig(h3,6,10,'exchangerates','.jpg')
        export_fig(metadata.fxHeaders{i},'-jpg','-r200');

    end
    
else
    error('Incorrect mode');
end

end

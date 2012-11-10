
function egCopula(theta,color,graph1,graph2,graph3,graph4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Simulated bivariate clayton copula with different margins
%   Alexandre Beaulne, Oct. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% color=true;
% color=false;

% theta=0.98;

%%%%%%%%%%%%%%%%%%%%%%% PLOT 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(graph1)
    
    N = 25000;

    U = copularnd('Clayton',theta,N);

    a = U(:,1);
    b = U(:,2);

    [n1,ctr1] = hist(a,75);
    n1 = n1/N;
    [n2,ctr2] = hist(b,75);
    n2 = n2/N;

    h = figure;
    set(h,'Color',[1 1 1]);

    subplot(2,2,2);
    h1 = plot(a(1:1000),b(1:1000),'.');
    axis([1.1*min(a(1:1000)) 1.1*max(a(1:1000)) 1.1*min(b(1:1000)) 1.1*max(b(1:1000))]);
    h2 = gca;
    xlabel('X1 ~ Uniform');
    ylabel('X2 ~ Uniform');

    subplot(2,2,4);
    h3 = bar(ctr1,-n1,1);
    axis([1.1*min(a(1:800)) 1.1*max(a(1:800)) -0.055 0]);
    h4 = gca;
    axis('off'); 

    subplot(2,2,1);
    h5 = barh(ctr2,-n2,1);
    axis([-0.13 0 1.1*min(b(1:800)) 1.1*max(b(1:800))]);
    h6 = gca;
    axis('off');

    set(h2,'Position',[0.35 0.35 0.55 0.55]);
    set(h4,'Position',[.35 .1 .55 .15]);
    set(h6,'Position',[.1 .35 .15 .55]);
    %colormap([.8 .8 1]);

    if(color)
            set(h1,'MarkerFaceColor','b');
            set(h1,'MarkerEdgeColor','b');
    else
        set(h1,'MarkerFaceColor','k');
        set(h1,'MarkerEdgeColor','k');
        set(h3,'FaceColor',[190/255 190/255 190/255])
        set(h5,'FaceColor',[190/255 190/255 190/255])
    end

    export_fig clayton3 -jpg -r300
end

%%%%%%%%%%%%%%%%%%%%%%% PLOT 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(graph2)
    
    N = 20000;

    U = mvnrnd([0 0],[1 0.6; 0.6 1],N);
    a = U(:,1);
    b = U(:,2);

    [n1,ctr1] = hist(a,75);
    n1 = n1/N;
    [n2,ctr2] = hist(b,75);
    n2 = n2/N;

    h = figure;
    set(h,'Color',[1 1 1]);

    subplot(2,2,2);
    h1 = plot(a(1:1000),b(1:1000),'.');
    axis([1.1*min(a(1:1000)) 1.1*max(a(1:1000)) 1.1*min(b(1:1000)) 1.1*max(b(1:1000))]);
    h2 = gca;
    xlabel('X1 ~ N(0,1)');
    ylabel('X2 ~ N(0,1)');

    subplot(2,2,4);
    h3 = bar(ctr1,-n1,1);
    axis([1.1*min(a(1:800)) 1.1*max(a(1:800)) -0.055 0]);
    h4 = gca;
    axis('off'); 

    subplot(2,2,1);
    h5 = barh(ctr2,-n2,1);
    axis([-0.13 0 1.1*min(b(1:800)) 1.1*max(b(1:800))]);
    h6 = gca;
    axis('off');

    set(h2,'Position',[0.35 0.35 0.55 0.55]);
    set(h4,'Position',[.35 .1 .55 .15]);
    set(h6,'Position',[.1 .35 .15 .55]);
    %colormap([.8 .8 1]);

    if(color)
        set(h1,'MarkerFaceColor','b');
        set(h1,'MarkerEdgeColor','b');
    else
        set(h1,'MarkerFaceColor','k');
        set(h1,'MarkerEdgeColor','k');
        set(h3,'FaceColor',[190/255 190/255 190/255])
        set(h5,'FaceColor',[190/255 190/255 190/255])
    end

    export_fig mvGaussian -jpg -r300
    
end

%%%%%%%%%%%%%%%%%%%%%%% PLOT 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(graph3)

    N = 20000;

    % Clayton - the inverse conditional CDF has a closed form for this copula

    u = rand(N,1);
    u1 = rand(N,1);

    v = u.*(u1.^(-theta./(1+theta)) - 1 + u.^theta).^(-1./theta);

    clear u1

    a = mixnorminv(u, 1, sqrt(2), -3, 2, 0.8);

    clear u

    b = tinv(v, 5)/sqrt(2);

    clear v

    [n1,ctr1] = hist(a,75);
    n1 = n1/N;
    [n2,ctr2] = hist(b,75);
    n2 = n2/N;

    h = figure;
    set(h,'Color',[1 1 1]);

    subplot(2,2,2);
    h1 = plot(a(1:1000),b(1:1000),'.');
    axis([1.1*min(a(1:1000)) 1.1*max(a(1:1000)) 1.1*min(b(1:1000)) 1.1*max(b(1:1000))]);
    h2 = gca;
    xlabel('X1 ~ Mixture of normals');
    ylabel('X2 ~ Student');

    subplot(2,2,4);
    h3 = bar(ctr1,-n1,1);
    axis([1.1*min(a(1:800)) 1.1*max(a(1:800)) -0.055 0]);
    h4 = gca;
    axis('off'); 

    subplot(2,2,1);
    h5 = barh(ctr2,-n2,1);
    axis([-0.13 0 1.1*min(b(1:800)) 1.1*max(b(1:800))]);
    h6 = gca;
    axis('off');

    set(h2,'Position',[0.35 0.35 0.55 0.55]);
    set(h4,'Position',[.35 .1 .55 .15]);
    set(h6,'Position',[.1 .35 .15 .55]);
    %colormap([.8 .8 1]);

    if(color)
        set(h1,'MarkerFaceColor','b');
        set(h1,'MarkerEdgeColor','b');
    else
        set(h1,'MarkerFaceColor','k');
        set(h1,'MarkerEdgeColor','k');
        set(h3,'FaceColor',[190/255 190/255 190/255])
        set(h5,'FaceColor',[190/255 190/255 190/255])
    end

    export_fig clayton -jpg -r300

end

%%%%%%%%%%%%%%%%%%%%%%% PLOT 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(graph4)

    x = [0:0.01:1]';
    y = [0:0.01:1]';

    n = length(x);

    z = NaN(n,n);

    for i = 1:n

        yv = fastrepmat(y(i),n,1);
        z(i,:) = copulacdf('Clayton',[x yv],theta);

    end

    h = figure;
    set(h,'Color',[1 1 1]);
    surf(x,y,z)
    xlabel('F_X(X)');
    ylabel('F_Y(Y)');
    zlabel('C_{\theta}(F_X(X),F_Y(Y))');
    view([-9 18])

    export_fig clayton2 -jpg -r300
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

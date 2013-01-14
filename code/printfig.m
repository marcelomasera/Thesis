function printfig(h,height,width,name,filetype,resolution)
% Pretty print a figure for publication in the desired format
%
% printfig(h,height,width,name,filetype,resolution)
%
% where
%       h is handle (i.e. pointer) of figure to print
%       height and width are in inches
%       name is a string with the file name
%       filetype is either '.eps','.pdf', '.png' or '.jpg'
%       resolution is dots-per-inch resolution
%
% Alexandre Beaulne, Mai 2012

    if(strcmp(filetype,'.eps'))
        filetype='-depsc2';
        renderer='-painters';
    elseif(strcmp(filetype,'.pdf'))
        filetype='-dpdf';
        renderer='-painters';
    elseif(strcmp(filetype,'.png'))
        filetype='-dpng';
        renderer='-opengl';
	elseif(strcmp(filetype,'.jpg'))
        filetype='-djpeg99';
        renderer='-opengl';
    else
        error('Incorrect file type. Must be ''.eps'',''.pdf'', ''.png'' or ''.jpg''.');
    end

    set(h, 'PaperPositionMode', 'manual');
    set(h, 'PaperUnits', 'inches');
    set(h, 'PaperPosition', [0 0 height width]);
    
    r = strcat('-r',int2str(round(resolution)));

    print(h,filetype,r,renderer,name);

end
function []=IEEE_format(xlab,ylab,tit,varargin)
%%1-D plot appearance according to the IEEE standard.
%%Input:
    % xlab: x-axis label
    % ylab: y-axis label
    % tit: title
    % varargin{1}: x-limit (1x2 vector)
    % varargin{2}: y-limit (1x2 vector)
    % varargin{3}: axis appearance (square, fill, etc.)
    %% Mandatory input
    xlabel(xlab,'FontSize',11,'fontname','times','Interpreter','tex');
    ylabel(ylab,'FontSize',11,'fontname','times','Interpreter','tex')
    title(tit,'FontSize',11,'fontname','times','FontWeight','normal','Interpreter','tex')
    set(gca,'FontSize',11,'linewidth',1.0);
    axis tight;box on;
    grid off
    ax = gca; ax.YAxis(1).LineWidth = 2.0;ax.XAxis.LineWidth = 2.0;
    set(ax,'fontname','arial');
    %% Non-mandatory input
    switch nargin
        case 4
            xlim(varargin{1});
        case 5
            xlim(varargin{1});
            ylim(varargin{2});
        case 6
            xlim(varargin{1});
            ylim(varargin{2});
            axis(varargin{3});
        case 7
            xlim(varargin{1});
            ylim(varargin{2});
            axis(varargin{3});
            set(gca,'XScale',varargin{4});
        case 8
            xlim(varargin{1});
            ylim(varargin{2});
            axis(varargin{3});
            set(gca,'XScale',varargin{4});
            set(gca,'YScale',varargin{5});
        case 9
            xlim(varargin{1});
            ylim(varargin{2});
            axis(varargin{3});
            set(gca,'XScale',varargin{4});
            set(gca,'YScale',varargin{5});
            set(gca,'FontSize',varargin{6});
    end
end
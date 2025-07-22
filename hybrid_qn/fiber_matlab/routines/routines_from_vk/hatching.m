function p_handle = hatching(f,g,xx,option)
% Hatching Area between two graphics
%
% f,g : functions to plot
% xx  : graphic support
% option : ploting options
%
% See 'DEMO MODE' for exemples
%- Hassan Ijtihadi
%- v1.0  9/04/2008
close
if nargin < 4
    % CHANGE OPTIONS HERE
    option.angle = 0.25*pi;  % 45?
    option.size = 30;        % lines number
    option.margin = 0.1;     % figure margin
    option.color = 'red';    % lines color
end
if nargin < 3
    %---------------------------
    % DEMO MODE
    p = floor(3*rand()-eps);
    switch p
        case 0
            % Sample -1-
            f = @cos;
            g = @sin;
            xx = 0:0.03:2*pi;
        case 1
            % Sample -2-
            f = @(x)(x.^1.5);
            g = @sin;
            xx = 0:0.02:2*pi;
        case 2
            % Sample -3-
            f = @(x)(ones(1,length(x)));
            g = @(x)(zeros(1,length(x)));
            xx = 0:0.03:2*pi;
    end
end
% Bounds & variables
d = [cos(option.angle) sin(option.angle)];
FMin = min([f(xx) ; g(xx)]);
FMax = max([f(xx) ; g(xx)]);
dxx = max(xx) - min(xx);
m = min(xx);
% Hatching
Xmin = linspace(min(FMin)-(d(2)/d(1))*dxx,max(FMax),option.size);
Xmax = linspace(min(FMin),max(FMax)+(d(2)/d(1))*dxx,option.size);
% Local Functions
DFMIN = @(x,x0) (FMin-(d(2)/d(1))*x-x0);
DFMAX = @(x,x0) (FMax-(d(2)/d(1))*x-x0);
ZF = @(x)(find(x(1:end-1).*x(2:end)<=0));
H = [];
XX = xx-m;
Xstart = Xmin >= FMin(1) & Xmin <= FMax(1);
Xend = Xmax >= FMin(end) & Xmax <= FMax(end);
%------------------------------------
% MAIN LOOP
for i=1:length(Xmin)
    x_min = DFMIN(XX, Xmin(i));
    x_max = DFMAX(XX, Xmin(i));
    zx_min = ZF(x_min);
    zx_max = ZF(x_max);
    Xtmp = [xx(zx_min)' min([f(xx(zx_min));g(xx(zx_min))])'];
    Xtmp = [Xtmp; xx(zx_max)' max([f(xx(zx_max));g(xx(zx_max))])'];
    [tmp ,IX] = sort(Xtmp(:,1));
    Xtmp = Xtmp(IX,:);
    % Add Start Points
    if Xstart(i)
        Xtmp = [xx(1) Xmin(i); Xtmp];
    end
    % Add End Points
    if Xend(i)
        Xtmp = [Xtmp; xx(end) Xmax(i)];
    end
    for j=1:2:(size(Xtmp,1)-mod(size(Xtmp,1),2))
        H = [H; Xtmp(j,:) Xtmp(j+1,:)];
    end
end
% Plot Lines
m = option.margin;
p_handle = figure();
plot(xx,f(xx),xx,g(xx));xlim([min(xx)-m*(max(xx)-min(xx)) max(xx)+m*(max(xx)-min(xx))])
ylim([min(FMin)-m*(max(FMax)-min(FMin)) max(FMax)+m*(max(FMax)-min(FMin))])
hold on
for i=1:size(H,1)
   line(H(i,[1 3]),H(i,[2 4]),'color',option.color)
end

clear
close all
clc
restoredefaultpath
addpath ./nurbs_toolbox/
addpath ./Functions
addpath ./Figures
%%
global order
N               = 100;      %Number of points along the chord
order           = 3;        %NURBS order
FlagWeight      = 1;        %Binary value: 1->optimize shape with weights; 0->optimize shape without weights
%% Load guessed airfoil convex hull
fid             = fopen(strcat('InitialPoints_2','.txt'),'r');              %Open the *txt file with the initial guessed NURBS control polygon
ControlPts      = textscan(fid, '%s', 'Delimiter','\n', 'HeaderLines', 0);
fclose(fid);

global xC
xC_all          = zeros(1,length(ControlPts{1}));                           %Initialize x- and y-coordinates of guessed control points
yC_all          = zeros(1,length(ControlPts{1}));

for j = 1:length(ControlPts{1})
    Line         = textscan(ControlPts{1}{j},'%f','Delimiter',',');
    
    xC_all(j)    = Line{1}(1);
    yC_all(j)    = Line{1}(2);
end
%% Load reference NACA airfoil
fid             = fopen(strcat('NACA_2412','.txt'),'r');                    %Open the *txt file with the reference coordinates
ControlPts      = textscan(fid, '%s', 'Delimiter','\n', 'HeaderLines', 0);
fclose(fid);

x_ref_all          = zeros(1,length(ControlPts{1}));                        %Initialize x- and y-coordinates of the reference airfoil
y_ref_all          = zeros(1,length(ControlPts{1}));
for j = 1:length(ControlPts{1})
    Line           = textscan(ControlPts{1}{j},'%f','Delimiter',',');
    
    x_ref_all(j)       = Line{1}(1);
    y_ref_all(j)       = Line{1}(2);
end
x_ref_all       = x_ref_all/max(x_ref_all)*100;                             %Re-scale the coordinates in percentage of the chord
y_ref_all       = y_ref_all*100;

global x_ref_int
x_ref_int       = linspace(0,max(x_ref_all),N);                             %Define a uniform grid along x with the user-defined number of points (N)
%% Optimize upper portion
x_ref           = x_ref_all(y_ref_all>=0);                                  %Select upper part
y_ref           = y_ref_all(y_ref_all>=0);

[x_ref,idx]     = unique(x_ref);
y_ref           = y_ref(idx);

global y_ref_int
y_ref_int       = interp1(x_ref,y_ref,x_ref_int,'linear','extrap');         %Interpolate reference coordinates on the uniform grid

xC              = xC_all(yC_all>=0);                                        %Select upper (guessed) control points
yC              = yC_all(yC_all>=0);
xC              = xC(1:end-1);
yC              = yC(1:end-1);
Boundary.low    = 0;                                                        %Set boundaries for the optimization
Boundary.up     = inf;
[Control_Up,Coordinate_Up,Error_Up]         = Optimize_Shape(xC,yC,Boundary,FlagWeight);    %Run the optimization
%% Optimize lower portion
x_ref           = x_ref_all(y_ref_all<=0);
y_ref           = y_ref_all(y_ref_all<=0);

[x_ref,idx]     = unique(x_ref);
y_ref           = y_ref(idx);

y_ref_int       = interp1(x_ref,y_ref,x_ref_int,'linear','extrap');

xC              = xC_all(yC_all<=0);
yC              = yC_all(yC_all<=0);
xC              = xC(2:end);
yC              = yC(2:end);
Boundary.low    = -inf;
Boundary.up     = 0;

[Control_Low,Coordinate_Low,Error_Low]         = Optimize_Shape(xC,yC,Boundary,FlagWeight);
%% Figure
fig         = figure('Units','inches','PaperPositionMode','auto','Position',[0 0 7.16 2.5]); 
plot(xC_all,yC_all,'ko-','MarkerSize',8)
hold on
plot([Control_Up.x Control_Low.x],[Control_Up.y; Control_Low.y],'ro-','MarkerSize',8)
hold on
plot([Coordinate_Up.x Coordinate_Low.x],[Coordinate_Up.y Coordinate_Low.y],'r.','MarkerSize',8)
hold on
plot(x_ref_all,y_ref_all,'b.','MarkerSize',8);
axis equal
IEEE_format('x/c','y/c','',[0 100],[-10 15]);
leg             = legend('Initial convex hull','Optimized convex hull','Optimized airfoil','NACA 2412');
leg.FontName    = 'arial';
leg.FontSize    = 11;
leg.Units       = 'inches';
leg.NumColumns  = 3;
leg.Position    = [0.9506    2.0258    3.8966    0.4236];
% saveas(fig,'Figures/Test_NURBS_03_all','fig')
% save2pdf('Figures/Test_NURBS_03_all',fig,150)
function [control, coordinate, error] = get_control_points(x_ref_all, y_ref_all, xC_all, yC_all, FlagWeight)

global order x_ref_int y_ref_int xC N 
x_ref_int       = linspace(0,max(x_ref_all),N);                             %Define a uniform grid along x with the user-defined number of points (N)
%% Optimize upper portion
x_ref           = x_ref_all(y_ref_all>=0);                                  %Select upper part
y_ref           = y_ref_all(y_ref_all>=0);

[x_ref,idx]     = unique(x_ref);
y_ref           = y_ref(idx);

y_ref_int       = interp1(x_ref,y_ref,x_ref_int,'linear','extrap');         %Interpolate reference coordinates on the uniform grid

xC              = xC_all(yC_all>=0);                                        %Select upper (guessed) control points
yC              = yC_all(yC_all>=0);
xC              = xC(1:end-1);
yC              = yC(1:end-1);
Boundary.low    = 0;
Boundary.up     = inf;

[Control_Up, Coordinate_Up, Error_Up]         = Optimize_Shape(xC,yC,Boundary,FlagWeight);    %Run the optimization
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

[Control_Low, Coordinate_Low, Error_Low]         = Optimize_Shape(xC,yC,Boundary,FlagWeight);

control.x = [Control_Up.x Control_Low.x];
control.y = [Control_Up.y; Control_Low.y];
control.w = [Control_Up.w; Control_Low.w];
coordinate.x = [Coordinate_Up.x Coordinate_Low.x];
coordinate.y = [Coordinate_Up.y Coordinate_Low.y];
error = [Error_Up Error_Low];
end
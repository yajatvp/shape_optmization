function [x, y] = get_airfoil(xd)
% get airfoil coordinates using control points of NURBS parameterization.
global order N controlx
xC              = controlx;
xC              = reshape(xC,1,[]);


x_ref_int       = linspace(0,1,N);

yC_Opt          = xd; %yOpt(1:length(yC0));                      % Select optimal y-control points
yC_Opt          = reshape(yC_Opt,1,[]);
weight_Opt      = ones(size(xC)); %yOpt(length(yC0)+1:end);      % Select optimal weights
weight_Opt      = reshape(weight_Opt,1,[]);
m               = size(xC,2) + order;                                                 %Calculate the number of knot points
knots           = [zeros(1,order-1) linspace(0,1,m-2*(order-1)) ones(1,order-1)];     %Define the knot vector

crv_Opt         = nrbmak([xC; yC_Opt;0*xC; weight_Opt],knots);                                        %Calculate the NURBS parameters
p_Opt           = nrbeval(crv_Opt,linspace(0,1,length(x_ref_int)));                   %Evaluate the NURBS curve for the specified number of points

y               = [flip(interp1(p_Opt(1,1:end/2),p_Opt(2,1:end/2),x_ref_int,'linear','extrap'))...
                    interp1(p_Opt(1,1+end/2:end),p_Opt(2,1+end/2:end),x_ref_int,'linear','extrap')];  %Interpolate the NURBS curve over the user-defined grid
x               = [flip(x_ref_int) (x_ref_int)];
end
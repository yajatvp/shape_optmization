function output = obj_fun(y)
%%Calculate the objective function of a shape optimization problem
%%Input:
    %y: y-coordinates and weight of the control points
%%Output
    %output: cost function evaluation (as Eq. 16 in Liang et al., 2010: "﻿Multi-objective robust airfoil optimization based on non-uniform rational B-spline(NURBS) representation")
    
    global x_ref_int y_ref_int xC order
    yC              = y(1:length(xC));          %Extract y-coordinates
    weights         = y(length(xC)+1:end);      %Extract weights
    
    m               = size(xC,2) + order;       %Calculate length of the knot vector
    knots           = [zeros(1,order-1) linspace(0,1,m-2*(order-1)) ones(1,order-1)];   %Evaluate knot vector
    crv             = nrbmak([xC; yC'; 0*xC; weights'],knots);                          %Evaluate NURBS parametrization
    p               = nrbeval(crv,linspace(0.0,1.0,length(x_ref_int)));                 %Evaluate the NURBS curve for the specified number of points
    p_int           = interp1(p(1,:),p(2,:),x_ref_int,'linear','extrap');               %Interpolate the NURBS curve over the user-defined grid

    output          = 2*(mean(abs(y_ref_int-p_int))/max(x_ref_int) + max(abs(y_ref_int-p_int)))/max(x_ref_int); %Calculate cost function
end
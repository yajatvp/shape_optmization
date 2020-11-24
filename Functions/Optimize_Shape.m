function [Control,Coordinate,Error]     = Optimize_Shape(xC,yC0,Boundary,flagWeight)
%%Script to optimize the shape of an airfoil given a reference profile.
%%Input:
    % xC: x-coordinates of the initial control points;
    % yC: y-coordinates of the initial control points;
    % Boundary: data structure with lower (.low) and upper (.up) boundaries for the y-control points
    % flagWeight: binary value indicating the optimization of the NURBS weights; 1-> optimization of the weights; 0-> optimization of the sole coordinates (weights=1)

%%Output:
    % Control: data structure containing the optimized control points;
    % Coordinate: data structure containing the optimized coordinates;
    % Error: data structure containing the error between the target and the optimized arifoil
    %% Create  guessed NURBS curve
    weights         = ones(1,length(yC0));      %Initialize weight vector
    %% Optimization
    LB              = zeros(2*length(yC0),1);   %Initialize lower and upper boundary vectors
    UB              = LB;

    %Boundaries on y
    LB(2:length(yC0)-1)     = Boundary.low;
    UB(2:length(yC0)-1)     = Boundary.up;

    %Boundaries on weights
    LB(length(yC0)+1:end)   = 1;
    if flagWeight==1
        UB(length(yC0)+1:end)   = Inf;
    else
        UB(length(yC0)+1:end)   = 1;
    end        

    %Set 1 the leading and trailing edge weights
    LB(length(yC0)+1)       = 1;
    UB(length(yC0)+1)       = 1;

    LB(end)                 = 1;
    UB(end)                 = 1;

    %Set options for optimization (through fmincon)
    options                 = optimoptions('fmincon','Display','none','StepTolerance',1e-07,'OptimalityTolerance',1e-07,'Algorithm','sqp','MaxIterations',200);
    [yOpt,fval]             = fmincon(@(x) obj_fun(x),[yC0 weights]',[],[],[],[],LB,UB,[],options);
    %% Shape optimal curve 
    yC_Opt          = yOpt(1:length(yC0));          %Select optimal y-control points
    weight_Opt      = yOpt(length(yC0)+1:end);      %Select optimal weights

    global order x_ref_int y_ref_int
    m               = size(xC,2) + order;           %Calculate the number of knot points
    knots           = [zeros(1,order-1) linspace(0,1,m-2*(order-1)) ones(1,order-1)];   %Define the knot vector

    crv_Opt         = nrbmak([xC; yC_Opt'; 0*xC; weight_Opt'],knots);                   %Calculate the NURBS parameters
    p_Opt           = nrbeval(crv_Opt,linspace(0,1,length(x_ref_int)));                 %Evaluate the NURBS curve for the specified number of points
    p_Opt_int       = interp1(p_Opt(1,:),p_Opt(2,:),x_ref_int,'linear','extrap');       %Interpolate the NURBS curve over the user-defined grid

    eps_Mean        = mean(abs(y_ref_int-p_Opt_int))/max(x_ref_int);                    %Calculate the mean error between reference and optimized airfoil
    eps_Max         = max(abs(y_ref_int-p_Opt_int))/max(x_ref_int);                     %Calculate the max. error between reference and optimized airfoil
    %% Results
    Error.Global    = fval;
    Error.Mean      = eps_Mean;
    Error.Max       = eps_Max;
    
    Control.x       = xC;
    Control.y       = yC_Opt;
    Control.w       = weight_Opt;
    
    Coordinate.x    = x_ref_int;
    Coordinate.y    = p_Opt_int;
end
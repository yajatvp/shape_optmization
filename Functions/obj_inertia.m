function f  = obj_inertia(xd)

% first convert the design vector (NURBS C.P.) to airfoil coords
t           = xd(end);  %Airfoil (constant) thickness
[xx,yy]     = get_airfoil(xd(1:end-1));

f           = get_moment_intertia(xx,yy,t); % polar moment of inertia

end

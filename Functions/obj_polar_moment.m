function f = obj_polar_moment(xd)
% get polar moment of inertia about the aerodynamic center for a given airfoil node points
global thick

t           = thick;  %Airfoil (constant) thickness
[xx,yy]     = get_airfoil(xd);

f = get_moment_intertia(xx, yy, t, 0) + get_moment_intertia(xx, yy, t, 90);

end
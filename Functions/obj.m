function f=obj(xd)
% first convert the design vector (NURBS C.P.) to airfoil coords
[xx,yy] = get_airfoil(xd);

f(1)    = get_perimeter(xx,yy); % volume of airfoil ~~ k(perimeter)
f(2)    = get_moment_intertia(xx,yy); % polar moment of inertia
end
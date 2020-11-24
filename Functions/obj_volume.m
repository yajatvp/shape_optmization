function f=obj_volume(xd)
% estimate airfoil volume from given airfoil NURBS control points and
% thickness - xd(end)
global thick
    % first convert the design vector (NURBS C.P.) to airfoil coords
    t           = thick;      %arifoil (constant) thickness
    [xx,yy]     = get_airfoil(xd);

    perimeter   = get_perimeter(xx,yy);        % volume of airfoil ~~ k(perimeter)
    f           = t*perimeter;
end

function [C, Ceq] = NONLCON(xd) % xd is the design vector for fmincon/any optimizer
global alpha Re Mach minCL maxCL maxCD max_t
% first convert the design vector (NURBS C.P.) to airfoil coords
[xx,yy] = get_airfoil(xd);

Ceq     = [];

coords = [xx; yy]';
%coords(abs(coords(:,:))<1e-8) = 0;

pol     = xfoil(coords,alpha,Re,Mach,'oper iter 900');
C(1)    = pol.CD - maxCD;
C(2)    = minCL - pol.CL;
%C(3)    = max(yy) - min(yy) - (max_t)/100;
C(3)    = pol.CL - maxCL;
% C(4)    = 0; % corresponds to the surface thickness constraint
end

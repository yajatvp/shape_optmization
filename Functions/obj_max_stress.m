function f = obj_max_stress(xd)
global alpha Re Mach thick

% first convert the design vector (NURBS C.P.) to airfoil coords
t           = thick;  %Airfoil (constant) thickness
[xx,yy]     = get_airfoil(xd);

% get resultant force inclination w.r.t. the airfoil chord
coords = [xx; yy]';
coords(abs(coords(:,:))<1e-4)=0;
pol     = xfoil(coords,alpha,Re,Mach,'oper iter 500');

% theta_0 = 90 - (atand(pol.CL/pol.CD) + alpha); % angle of axis perpendicular to resultant force direction

% I = get_moment_intertia(xx, yy, t, theta_0); % moment of inertia passing through the line from A.C., perpendicular to resultant aerodynamic force.
% f = get_moment_intertia(xx, yy, t, alpha);
% 
% y0 = abs(0-tand(-theta_0)*(1-0.25))/sqrt(1 + (tand(-theta_0))^2 ); % dist of trailing edge point (1, 0) from axis
% 
tau_s = sqrt(pol.CL^2 + pol.CD^2)./(t*get_perimeter(xx,yy)); % shear stress
% M = (sqrt(pol.CL^2 + pol.CD^2))*(0.5); % bending moment
% 
% sigma_b = (M/I)*y0; % max bending stress
% 
% f = sqrt(sigma_b^2 + 3*tau_s^2); % von-mises stress
% % pol.CL
f = tau_s;
end
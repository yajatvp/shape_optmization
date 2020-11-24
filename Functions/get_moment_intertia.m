function f = get_moment_intertia(xx, yy, t, theta_0)
% Calculate w.r.t the axis inclined at an angle of theta_0, passing through the 
% aerodynamic center - [c/4,0]=[1/4,0].
% Ixx = (ab/12) * (b^2 cos^2(phi) + a^2 sin^2(phi))

f = 0;
for i = 1:size(xx,2)-1
    [xm] = (xx(i)+xx(i+1))*0.5;
    [ym] = (yy(i)+yy(i+1))*0.5;
    
    if xm == 0 && ym ==0
        continue
    end
    
    alpha_0 = atand( (yy(i+1)-yy(i))/(xx(i+1)-xx(i)) ); % angle of inclination of the discretized line segment:
    rel_ang = alpha_0 + theta_0; % relative inclination of line seg. w.r.t. the axis
    
    if theta_0 == 90
        d = (xm - 0.25);
    else
        d = abs(ym-tand(-theta_0)*(xm-0.25))/sqrt(1 + (tand(-theta_0))^2 ); % dist of the midpoint from the line inclined at an angle of (-theta_0), passing through the aerodynamic center - [c/4,0]=[1/4,0]
    end
    
    l = sqrt((xx(i+1)-xx(i))^2+(yy(i+1)-yy(i))^2);
    f = f + (1/12)*(l*t)*( t^2*(cosd(rel_ang)^2) + l^2*(sind(rel_ang)^2) ) + (l*t)*d^2;
end
end
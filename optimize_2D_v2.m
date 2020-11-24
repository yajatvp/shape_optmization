clc
clear;
addpath ./nurbs_toolbox/
addpath ./Functions
addpath ./Test
%% MECH 6318: Engineering Optimization Project
% This code optimizes a 2D airfoil for total volume and polar moment of
% inertia about the aerodynamic centre. The total volume is simply the
% perimeter times the thickness, and the polar moment of inertia is
% estimated using discretized nodes along the perimeter of the airfoil. The
% volume is a manufacturing-cost based objective #1 and the inverse polar moment 
% is the relative twist along the spanwise direction - based objective #2.
% This optimization is conducted using the NURBS parameterization and
% aerodynamic constraints for the lift and drag coefficients. 
% This code uses MATLAB's Xfoil function to solve an incompressible flow
% around a 2D airfoil and optimizes it using the MATLAB's fmincon solver.
%% Initialization

% Airfoil details
c = 1; % Non-dim chord length - DO NOT CHANGE.
v = 30; % freestream velocity in m/s
mu = 1.48e-5; % kinematic viscosity of air
global alpha Re Mach minCL maxCL maxCD max_t N order controlx thick;
alpha = 3; % Angle of attack in degrees
Re = 0.3*v/mu; % Reynolds no. of the flow. Here 0.3 is the actual length in meters, of the airfoil chord.
Mach = v/343; % Mach no.
minCL = 1.2;  % Min. CL for design
maxCL = 2.8;  % Max. CL for design. Set it to 'Inf' if not necessary for the flow application.
maxCD = 0.2;  % Max. CD for design
thick = 0.01; % Airfoil surface thickness

max_t = 50; % Airfoil max. thickness percentage w.r.t chord [eg. 5% = 0.05*c ] (NOT surface thickness)
N               = 100;      % Number of node points along the chord
order           = 3;        % NURBS order

%% Load NURBS control points for the initial airfoil to be optimized
load('.\s1223rtl-il.mat'); % loads the NURBS control points for the s1223 airfoil.

% global xC
controlx = ControlPoints(:,1)/max(ControlPoints(:,1));
controly = ControlPoints(:,2)/(max(ControlPoints(:,1)));

[x_ref_all, y_ref_all] = get_airfoil(controly);
pol_init     = xfoil([x_ref_all; y_ref_all]',alpha,Re,Mach,'oper iter 300');
%% CALL FMINCON

% Lower and upper bounds for the NURBS control points
LB              = [controly - 0.2*abs(controly)]; 
UB              = [controly + 0.2*abs(controly)];
options         = optimoptions('fmincon','Display','iter-detailed','StepTolerance',1e-07,'OptimalityTolerance',1e-07,'Algorithm','sqp','MaxIterations',200);

% Optimization weights (to generate the Pareto frontier)
mu1             = linspace(0.1, 0.9, 15);%(0.1:0.7/20:0.9);
mu2             = 1 - mu1;
    
% Scaling the objective functions
n1 = 1/obj_polar_moment([controly]);
n2 = obj_volume([controly]);

% Optimize for all points along the Pareto front
for i = 1:size(mu1,2)
    tic;
    [xd_result,fval,exitflag,output,lambda,grad,hessian]  = fmincon(@(xd)...
        mu1(i)*1/obj_polar_moment(xd)/n1 + (mu2(i)*obj_volume(xd))/n2, ...
        [controly], [], [], [], [], LB, UB, @(xd) NONLCON(xd), options);
    tim(i) = toc;
    
    controly_res(i,:) = xd_result;
    [x_opt(i,:), y_opt(i,:)] = get_airfoil(controly_res(i,:)');
    
    coords = [x_opt(i,:); y_opt(i,:)]';
    pol(i)     = xfoil(coords,alpha,Re,Mach,'oper iter 300');
    
    i
end
%% Plot for the pareto frontier
for i = 1:size(pol,2)
    CL(i)=pol(i).CL;
    CD(i)=pol(i).CD;
    inv_I(i) = obj_polar_moment([controly_res(i,:)]');
    vol(i) = obj_volume([controly_res(i,:)]');
end

fig = figure('Units','inches','PaperPositionMode','auto','Position',[0 0 7.16 2.5]);
subplot(3,1,1)
yyaxis left
plot(CL);grid on; hold on;
yyaxis right
plot(CD)

subplot(3,1,2)
plot(inv_I); grid on;

subplot(3,1,3)
plot(vol); grid on;

% Plot the Pareto front
figure;
scatter(inv_I, vol, 75); grid on;
xlabel('Inverse Polar Moment - 1/I [Scaled w.r.t. inital airfoil]'); ylabel('Volume [Scaled w.r.t. inital airfoil]')

% Plot all airfoil shapes
for i = 1:size(pol,2)
    hold on
    plot(x_opt(i,:),y_opt(i,:),'.','MarkerSize',8);axis equal;grid on; hold on;
    waitforbuttonpress
%     close
end

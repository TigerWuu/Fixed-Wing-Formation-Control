%% fixed wing initial condition in trim states
init = struct();
init.Va0 = 18; % [m/s] (63 km/h) cruise speed
init.theta0 = 0; % [rad]
init.psi0 = 0; % [rad]
init.phi0 = 0; % [rad]
init.course0 = 0; % [rad]

% NED frame
init.x0 = 0; % [m]
init.y0 = 0; % [m]
init.z0 = -90; % [m]
% ENU frame
init.h0 = -init.z0; % [m]

%% enviroment constants
env = struct();
% gravity
env.g = 9.81; % [m/s^2]
% air density
env.rho = 1.2682; % [kg/m^3]
% wind (ned)
env.w.s = 5; % [m/s]
env.w.dir = pi/6; % [rad]

%% Inner loop times constant
alpha = 0.5;
beta = 0.5;

%% Desired formation
lc = [0,2.2,-2.2];
fc = [0,2.2,2.2];
hc = [0,0,0];
%% Discrete
ts = 1;
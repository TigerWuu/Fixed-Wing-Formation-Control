%% fixed wing initial condition in trim states
init = struct();
init.Va0 = 18; % [m/s] (63 km/h) cruise speed
init.theta0 = 0; % [rad]
init.psi0 = pi/18; % [rad]
init.phi0 = 0; % [rad]
init.course0 = 0; % [rad]

% NED frame
init.x0 = 1.0; % [m]
init.y0 = 1.0; % [m]
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
env.w.s = 2; % [m/s]
env.w.dir = 0; % [rad]

%% Leader paramters
leader = struct();
leader.va = 18;
% straight line
leader.dir = 0;
% circle
leader.radius = 200;

%% Inner loop inverse time constant
tau = struct();
tau.va = 0.5;
tau.psi = 0.4;
tau.theta = 0.1;
%% observer/formation gain
L = 1;
c1 = 1.0;
c2 = 0.2;
c3 = 1.0;
c4 = 0.2;
c5 = 0.2;
c6 = 5;
C = [c1, c2, c3, c4 ,c5, c6];% le, fe, he, va_e, psi_e, theta_e
% c1 = 0.1;
% c2 = 0.1;
% c3 = 0.1;
%% Desired formation
lc = [0,2.2,-2.2];
fc = [0,2.2,2.2];
hc = [0,0,0];

%% limitation
Va_max = Inf;
Va_min = -Inf;
% Va_max = 28;
% Va_min = 12;

%% Discrete
ts = 1;
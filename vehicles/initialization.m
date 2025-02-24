%% fixed wing initial condition in trim states
init = struct();
init.Va0 = 18; % [m/s] (63 km/h) cruise speed
init.theta0 = 0; % [rad]
init.psi0 = 0; % [rad] pi/18
init.phi0 = 0; % [rad]
init.course0 = 0; % [rad]

% NED frame
init.x0 = 0.0; % [m]
init.y0 = 0.0; % [m]
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
env.w.dir = 3*pi/4; % [rad]

%% Leader paramters
leader = struct();
leader.va = 18;
% straight line
leader.dir = pi/4;
% circle
leader.radius = 400;

%% Inner loop inverse time constant
tau = struct();
% Px4 from manual calculation
% tau.va = 0.26;
% tau.psi = 0.1;
% tau.theta = 1.3;

% Px4 from tfest
% tau.va = 0.1918;
% tau.psi = 0.0841;
% tau.theta = 2.012;

tau.va = 0.5;
tau.psi = 0.5;
tau.theta = 0.5;
%% observer/formation gain
L = 1;
L2 = 0.1;

% px4 gain
% c1 = 1.0;
% c2 = 1.0;
% c3 = 1.0;
% c4 = 0.3;
% c5 = 0.3;
% c6 = 3.0;

c1 = 0.2;
c2 = 0.2;
c3 = 1.0;
c4 = 0.4;
c5 = 0.4;
c6 = 3.0;

% c1 = 1.0;
% c2 = 1.0;
% c3 = 1.0;
% c4 = 3.0;
% c5 = 3.0;
% c6 = 3.0;
C = [c1, c2, c3, c4 ,c5, c6];% le, fe, he, va_e, psi_e, theta_e

%% Desired formation
lc = [0,-7,-2.2];
fc = [0,14.0,2.2];
hc = [0,0,0];

%% limitation
Va_max = Inf;
Va_min = -Inf;
% Va_max = 28;
% Va_min = 12;

%% Discrete
ts = 1;

%% wind compensation
com = 0;

%% Sim time
SimTime = 100;
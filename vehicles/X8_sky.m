run('initialization.m'); % initialize global variables

%% create fixed-wing X8 vehicle
X8 = struct();
X8.name = 'Skywalker X8';
X8.m = 3; % [kg]
X8.b = 2.12; % [m]
X8.c = 0.357; % [m]
X8.Ixx = 0.1147; % [kg*m^2]
X8.Iyy = 0.0576; % [kg*m^2]
X8.Izz = 0.1712; % [kg*m^2]
X8.Ixz = 0.0015; % [kg*m^2]
X8.S = 0.75; % [m^2]

% control inputs saturation limits
X8.delta.e_max = 60*pi/180; % [rad]
X8.delta.e_min = -X8.delta.e_max; % [rad]
X8.delta.a_max = 25*pi/180; % [rad]
X8.delta.a_min = -X8.delta.a_max; % [rad]
% XM2834EA V3 2316EA KV1160 
X8.delta.t_max = 1.456*env.g; % force [N]
X8.delta.t_star = 0.5*X8.delta.t_max; % force[N] 
X8.delta.t_min = 0; % force [N]


% aerodynamic coefficients (by XFLR5)
CD = 0.107;
CD_alpha = -0.00955;
CD_delta_e = 0.0196;

CY = 0.0;
CY_r = 0.0839;
CY_beta = -0.194;
CY_delta_a = 0.0439;
CY_delta_r = 0.0; % missing data

CL = 0.0477;
CL_q = 3.87;
CL_alpha = 4.06;
CL_delta_e = 0.7;

Cl = 0.0;
Cl_p = -0.404;
Cl_r = 0.0555;
Cl_beta = -0.0751;
Cl_delta_a = 0.202;
Cl_delta_r = 0.0; % missing data

Cm = 0.00439;
Cm_q = -1.3;
Cm_alpha = -0.227;
Cm_delta_e = -0.325;

Cn = 0.0;
Cn_p = 0.00437;
Cn_r = -0.012;
Cn_beta = 0.0312;
Cn_delta_a = -0.00628;
Cn_delta_r = 0.0; % missing data

% model (linearized at trim states)
te = 1/2*env.rho*init.Va0^2*X8.S;
G_Lo = [X8.m-0, 0, 0, 0, 0, 0;
        0, X8.m-0, 0, 0, 0, 0;
        0, 0, X8.Iyy, 0, 0, 0;
        0, 0,      0, 1, 0, 0;
        0, 0,      0, 0, 1, 0;
        0, 0,      0, 0, 0, 1];
G_La = [X8.m,0     ,0     ,0, 0, 0;
        0   ,X8.Ixx,0     ,0, 0, 0;
        0   ,0     ,X8.Izz,0, 0, 0;
        0   ,0     ,0     ,1, 0, 0;
        0   ,0     ,0     ,0, 1, 0;
        0   ,0     ,0     ,0, 0, 1];
% longitudinal
X8.model.lo.A = inv(G_Lo)*[te*(-2*CD/init.Va0)    , te*((CL-CD_alpha)/init.Va0)  , 0                       , 0, 0, -X8.m*env.g*cos(init.theta0);
                           te*(-2*CL/init.Va0)    , te*((-CD-CL_alpha)/init.Va0) , te*(-CL_q)+X8.m*init.Va0, 0, 0, -X8.m*env.g*sin(init.theta0);
                           te*(2*X8.c*Cm/init.Va0), te*((X8.c*Cm_alpha)/init.Va0), te*(X8.c*Cm_q)          , 0, 0,                            0;
                           cos(init.theta0)       , sin(init.theta0)             , 0                       , 0, 0,                            0;
                           -sin(init.theta0)      , cos(init.theta0)             , 0                       , 0, 0,                            0;
                           0                      , 0                            , 1                       , 0, 0,                            0];
X8.model.lo.B = inv(G_Lo)*[te*(-CD_delta_e), 1;
                           te*(-CL_delta_e), 0;
                           te*(X8.c*Cm_delta_e),0;
                           0               , 0;
                           0               , 0;
                           0               , 0]; 
% X8.model.lo.C = [1, 0, 0, 0, 0, 0
%                  0, 0, 0, 0, 1, 0]; % velocity and altitude

X8.model.lo.C = [1, 0, 0, 0, 0, 0]; % velocity

X8.model.lo.D = zeros(1,2);

% lateral
X8.model.la.A = inv(G_La)*[te*(CY_beta/init.Va0)      , 0               , te*CY_r-X8.m*init.Va0 , 0, X8.m*env.g*cos(init.theta0), 0;
                           te*(X8.b*Cl_beta/init.Va0) , te*(X8.b*Cl_p)  , te*(X8.b*Cl_r)   , 0, 0,                  0;
                           te*(X8.b*Cn_beta/init.Va0) , te*(X8.b*Cn_p)  , te*(X8.b*Cn_r)   , 0, 0,                  0;
                           1                     , 0               , 0                , 0, 0,                  0;
                           0                     , 1               , tan(init.theta0)      , 0, 0,                  0;
                           0                     , 0               , sec(init.theta0)      , 0, 0,                  0];
X8.model.la.B = inv(G_La)*[te*(CY_delta_a)  , te*(CY_delta_r)  ;
                           te*(X8.b*Cl_delta_a), te*(X8.b*Cl_delta_r);
                           te*(X8.b*Cn_delta_a), te*(X8.b*Cn_delta_r);
                           0                ,                 0;
                           0                ,                 0;
                           0                ,                 0]; 

X8.model.la.D = zeros(1,2);
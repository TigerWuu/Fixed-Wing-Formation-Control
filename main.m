clc;
clear;
close all;
 

run("vehicles/X8_sky.m")

% P1 delta_e -> q
C_q = [0, 0, 1, 0, 0, 0];
% P1 delta_e -> theta
C_theta = [0, 0, 0, 0, 0, 1];
% throttle -> u
C_throttle = [1, 0, 0, 0, 0, 0];
% throttle -> v
C_throttle_v = [1, 0, 0, 0, 0, 0];
% throttle -> w
C_throttle_w = [0, 1, 0, 0, 0, 0];

% delta_a -> p
C_p = [0, 1, 0, 0, 0, 0];
% delta_a -> r
C_r = [0, 0, 1, 0, 0, 0];

% longitudinal
X8_lon_q_ss = ss(X8.model.lo.A, X8.model.lo.B, C_q, X8.model.lo.D);
X8_lon_u_ss = ss(X8.model.lo.A, X8.model.lo.B, C_throttle, X8.model.lo.D);
X8_lon_w_ss = ss(X8.model.lo.A, X8.model.lo.B, C_throttle_w, X8.model.lo.D);

X8_lon_q_tf = tf(X8_lon_q_ss);
X8_lon_u_tf = tf(X8_lon_u_ss);
X8_lon_w_tf = tf(X8_lon_w_ss);
X8_lon_de_q_tf = X8_lon_q_tf(1);
X8_lon_th_u_tf = X8_lon_u_tf(2);
X8_lon_th_w_tf = X8_lon_w_tf(2);

% lateral
X8_lat_p_ss = ss(X8.model.la.A, X8.model.la.B, C_p, X8.model.la.D);
X8_lat_r_ss = ss(X8.model.la.A, X8.model.la.B, C_r, X8.model.la.D);
X8_lat_v_ss = ss(X8.model.la.A, X8.model.la.B, C_throttle_v, X8.model.la.D);
X8_lat_p_tf = tf(X8_lat_p_ss);
X8_lat_v_tf = tf(X8_lat_v_ss);
X8_lat_r_tf = tf(X8_lat_r_ss);
X8_lat_da_p_tf = X8_lat_p_tf(1);
X8_lat_da_v_tf = X8_lat_v_tf(1);
X8_lat_da_r_tf = X8_lat_r_tf(1);

s = tf('s');
[k_theta,info] = pidtune(X8_lon_de_q_tf*1/s,'PD')
[k_Va,info_Va] = pidtune(X8_lon_th_u_tf,'PI')
[k_phi,info_phi] = pidtune(X8_lat_da_p_tf*1/s,'PD')

% sim_model = 'FW_control';
% simIn = Simulink.SimulationInput(sim_model);
% out = sim(simIn);


